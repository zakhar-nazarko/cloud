data "aws_caller_identity" "current" {}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "react_app" {
  bucket        = "react-app-bucket-${random_id.suffix.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "react_app_block" {
  bucket                  = aws_s3_bucket.react_app.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.react_app.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

locals {
  files = fileset("${path.module}/react-app-frontend/build", "**")
}

resource "aws_s3_object" "react_build_files" {
  for_each     = { for file in local.files : file => file }
  bucket       = aws_s3_bucket.react_app.id
  key          = each.value
  source       = "${path.module}/react-app-frontend/build/${each.value}"
  etag         = filemd5("${path.module}/react-app-frontend/build/${each.value}")
  content_type = lookup(var.mime_types, regex("\\.[^.]+$", each.value), "application/octet-stream")
}

resource "aws_cloudfront_origin_access_identity" "react_oai" {
  comment = "React app OAI"
}

resource "aws_s3_bucket_policy" "react_policy" {
  bucket = aws_s3_bucket.react_app.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowCloudFrontRead",
        Effect = "Allow",
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.react_oai.iam_arn
        },
        Action   = ["s3:GetObject"],
        Resource = ["${aws_s3_bucket.react_app.arn}/*"]
      }
    ]
  })
}

resource "aws_cloudfront_distribution" "react_dist" {
  origin {
    domain_name = aws_s3_bucket.react_app.bucket_regional_domain_name
    origin_id   = "S3ReactOrigin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.react_oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3ReactOrigin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.react_dist.domain_name}"
}

output "bucket_name" {
  value = aws_s3_bucket.react_app.bucket
}

variable "mime_types" {
  type = map(string)
  default = {
    ".html"  = "text/html"
    ".js"    = "application/javascript"
    ".css"   = "text/css"
    ".json"  = "application/json"
    ".ico"   = "image/x-icon"
    ".svg"   = "image/svg+xml"
    ".png"   = "image/png"
    ".jpg"   = "image/jpeg"
    ".jpeg"  = "image/jpeg"
    ".woff"  = "font/woff"
    ".woff2" = "font/woff2"
  }
}

resource "aws_iam_policy" "s3_react_policy" {
  name        = "S3ReactAppPolicy"
  description = "Allow Terraform to manage S3 static site and CloudFront"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetBucketWebsite",
          "s3:GetBucketPolicy",
          "s3:PutBucketWebsite",
          "s3:PutBucketPolicy",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.react_app.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.react_app.bucket}/*"
        ]
      }
    ]
  })
}
resource "aws_iam_user" "terraform_user" {
  name = "terraform-s3-react-user"
}

resource "aws_iam_user_policy_attachment" "attach_s3_policy" {
  user       = aws_iam_user.terraform_user.name
  policy_arn = aws_iam_policy.s3_react_policy.arn
}

