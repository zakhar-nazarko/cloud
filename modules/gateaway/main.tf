module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = var.context
}

resource "aws_api_gateway_rest_api" "courses_api" {
  name        = "Courses_API"
  description = "Example Courses API"
}

resource "aws_api_gateway_resource" "authors" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  parent_id   = aws_api_gateway_rest_api.courses_api.root_resource_id
  path_part   = "authors"
}

resource "aws_api_gateway_resource" "courses" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  parent_id   = aws_api_gateway_rest_api.courses_api.root_resource_id
  path_part   = "courses"
}

resource "aws_api_gateway_resource" "course_by_id" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  parent_id   = aws_api_gateway_resource.courses.id
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "get_authors" {
  rest_api_id   = aws_api_gateway_rest_api.courses_api.id
  resource_id   = aws_api_gateway_resource.authors.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_authors_integration" {
  rest_api_id             = aws_api_gateway_rest_api.courses_api.id
  resource_id             = aws_api_gateway_resource.authors.id
  http_method             = aws_api_gateway_method.get_authors.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.get_all_authors_invoke_arn
}

resource "aws_api_gateway_method_response" "get_authors_response" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.authors.id
  http_method = aws_api_gateway_method.get_authors.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "get_authors_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.authors.id
  http_method = aws_api_gateway_method.get_authors.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET'"
  }

  depends_on = [
    aws_api_gateway_integration.get_authors_integration,
    aws_api_gateway_method_response.get_authors_response
  ]
}

resource "aws_api_gateway_method" "get_courses" {
  rest_api_id   = aws_api_gateway_rest_api.courses_api.id
  resource_id   = aws_api_gateway_resource.courses.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_courses_integration" {
  rest_api_id             = aws_api_gateway_rest_api.courses_api.id
  resource_id             = aws_api_gateway_resource.courses.id
  http_method             = aws_api_gateway_method.get_courses.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.get_all_courses_invoke_arn
}

resource "aws_api_gateway_method_response" "get_courses_response" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.get_courses.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "get_courses_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.get_courses.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET'"
  }

  depends_on = [
    aws_api_gateway_integration.get_courses_integration,
    aws_api_gateway_method_response.get_courses_response
  ]
}

resource "aws_api_gateway_method" "save_course" {
  rest_api_id   = aws_api_gateway_rest_api.courses_api.id
  resource_id   = aws_api_gateway_resource.courses.id
  http_method   = "POST"
  authorization = "NONE"
  request_models = {
    "application/json" = aws_api_gateway_model.course_input_model.name
  }
  request_validator_id = aws_api_gateway_request_validator.post_course_validator.id
}

resource "aws_api_gateway_integration" "post_save_course_integration" {
  rest_api_id             = aws_api_gateway_rest_api.courses_api.id
  resource_id             = aws_api_gateway_resource.courses.id
  http_method             = aws_api_gateway_method.save_course.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.post_save_course_invoke_arn
}

resource "aws_api_gateway_request_validator" "post_course_validator" {
  rest_api_id                 = aws_api_gateway_rest_api.courses_api.id
  name                        = "Validate body"
  validate_request_body       = true
  validate_request_parameters = false
}

resource "aws_api_gateway_model" "course_input_model" {
  rest_api_id  = aws_api_gateway_rest_api.courses_api.id
  name         = "CourseInputModel"
  content_type = "application/json"
  schema = jsonencode({
    "$schema" : "http://json-schema.org/schema#",
    "title" : "CourseInputModel",
    "type" : "object",
    "properties" : {
      "title" : { "type" : "string" },
      "authorId" : { "type" : "string" },
      "length" : { "type" : "string" },
      "category" : { "type" : "string" }
    },
    "required" : ["title", "authorId", "length", "category"]
  })
}

resource "aws_api_gateway_method" "get_course" {
  rest_api_id   = aws_api_gateway_rest_api.courses_api.id
  resource_id   = aws_api_gateway_resource.course_by_id.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_course_integration" {
  rest_api_id             = aws_api_gateway_rest_api.courses_api.id
  resource_id             = aws_api_gateway_resource.course_by_id.id
  http_method             = aws_api_gateway_method.get_course.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.get_course_by_id_invoke_arn
}






resource "aws_api_gateway_method" "delete_course" {
  rest_api_id   = aws_api_gateway_rest_api.courses_api.id
  resource_id   = aws_api_gateway_resource.course_by_id.id
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "delete_course_integration" {
  rest_api_id             = aws_api_gateway_rest_api.courses_api.id
  resource_id             = aws_api_gateway_resource.course_by_id.id
  http_method             = aws_api_gateway_method.delete_course.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.delete_course_by_id_invoke_arn
}





resource "aws_api_gateway_method" "put_course" {
  rest_api_id   = aws_api_gateway_rest_api.courses_api.id
  resource_id   = aws_api_gateway_resource.course_by_id.id
  http_method   = "PUT"
  authorization = "NONE"
  request_models = {
    "application/json" = aws_api_gateway_model.course_input_model.name
  }
  request_validator_id = aws_api_gateway_request_validator.post_course_validator.id
}

resource "aws_api_gateway_integration" "put_course_integration" {
  rest_api_id             = aws_api_gateway_rest_api.courses_api.id
  resource_id             = aws_api_gateway_resource.course_by_id.id
  http_method             = aws_api_gateway_method.put_course.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.put_update_course_invoke_arn
}



resource "aws_api_gateway_method" "options_course_by_id" {
  rest_api_id   = aws_api_gateway_rest_api.courses_api.id
  resource_id   = aws_api_gateway_resource.course_by_id.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_course_by_id_integration" {
  rest_api_id          = aws_api_gateway_rest_api.courses_api.id
  resource_id          = aws_api_gateway_resource.course_by_id.id
  http_method          = aws_api_gateway_method.options_course_by_id.http_method
  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = <<EOF
{
  "statusCode": 200
}
EOF
  }

}

resource "aws_api_gateway_method_response" "options_course_by_id_response_200" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.course_by_id.id
  http_method = aws_api_gateway_method.options_course_by_id.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_lambda_permission" "apigw_lambda_permissions" {
  for_each      = var.lambda_permissions
  statement_id  = each.value.statement_id
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.courses_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "apigw_deploy" {
  depends_on = [
    aws_api_gateway_integration.get_authors_integration,
    aws_api_gateway_integration.post_save_course_integration,
    aws_api_gateway_integration.put_course_integration,
    aws_api_gateway_integration.get_courses_integration,
    aws_api_gateway_integration.delete_course_integration,
    aws_api_gateway_integration.get_course_integration,
    aws_api_gateway_integration_response.get_authors_integration_response,
    aws_api_gateway_integration_response.get_courses_integration_response
  ]
  rest_api_id = aws_api_gateway_rest_api.courses_api.id

  triggers = {
    redeploy = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.apigw_deploy.id
  rest_api_id   = aws_api_gateway_rest_api.courses_api.id
  stage_name    = "prod"
}

resource "aws_api_gateway_method_response" "get_course_response_200" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.course_by_id.id
  http_method = aws_api_gateway_method.get_course.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "get_course_response_200" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.course_by_id.id
  http_method = aws_api_gateway_method.get_course.http_method
  status_code = aws_api_gateway_method_response.get_course_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET'"
  }
}

resource "aws_api_gateway_method_response" "delete_course_response_200" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.course_by_id.id
  http_method = aws_api_gateway_method.delete_course.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "delete_course_response_200" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.course_by_id.id
  http_method = aws_api_gateway_method.delete_course.http_method
  status_code = aws_api_gateway_method_response.delete_course_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE'"
  }
}

resource "aws_api_gateway_method_response" "put_course_response_200" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.course_by_id.id
  http_method = aws_api_gateway_method.put_course.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "put_course_response_200" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.course_by_id.id
  http_method = aws_api_gateway_method.put_course.http_method
  status_code = aws_api_gateway_method_response.put_course_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'PUT'"
  }
}

resource "aws_api_gateway_integration_response" "options_course_by_id_integration" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.course_by_id.id
  http_method = aws_api_gateway_method.options_course_by_id.http_method
  status_code = aws_api_gateway_method_response.options_course_by_id_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.options_course_by_id,
    aws_api_gateway_method_response.options_course_by_id_response_200
  ]
}
