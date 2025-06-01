provider "aws" {
  region = "eu-central-1"
}


resource "aws_s3_bucket" "tf_state" {
  bucket        = "lpnu-zakhar-backend"
  force_destroy = true

}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_encryption" {
  bucket = aws_s3_bucket.tf_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_dynamodb_table" "tf_locks" {
  name         = "lpnu-zakhar-backend"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
