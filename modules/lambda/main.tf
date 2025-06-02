module "label_get_all_authors" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = var.context
  name    = "get-all-authors"
}

module "label_get_all_courses" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = var.context
  name    = "get-all-courses"
}

module "label_get_course" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = var.context
  name    = "get-course"
}

module "label_save_course" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = var.context
  name    = "save-course"
}

module "label_update_course" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = var.context
  name    = "update-course"
}

module "label_delete_course" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = var.context
  name    = "delete-course"
}

resource "aws_lambda_function" "get_all_authors" {
  function_name    = module.label_get_all_authors.id
  role             = var.lambda_exec_role_arn
  runtime          = "python3.12"
  handler          = "get_all_authors.lambda_handler"
  filename         = data.archive_file.get_all_authors.output_path
  source_code_hash = data.archive_file.get_all_authors.output_base64sha256
}

data "archive_file" "get_all_authors" {
  type        = "zip"
  source_file = "${path.module}/src/get_all_authors/get_all_authors.py"
  output_path = "${path.module}/src/get_all_authors/get_all_authors.zip"
}

resource "aws_lambda_function" "get_all_courses" {
  function_name    = module.label_get_all_courses.id
  role             = var.lambda_exec_role_arn
  runtime          = "python3.12"
  handler          = "get_all_courses.lambda_handler"
  filename         = data.archive_file.get_all_courses.output_path
  source_code_hash = data.archive_file.get_all_courses.output_base64sha256
}

data "archive_file" "get_all_courses" {
  type        = "zip"
  source_file = "${path.module}/src/get_all_courses/get_all_courses.py"
  output_path = "${path.module}/src/get_all_courses/get_all_courses.zip"
}

resource "aws_lambda_function" "get_course" {
  function_name    = module.label_get_course.id
  role             = var.lambda_exec_role_arn
  runtime          = "python3.12"
  handler          = "get_course.lambda_handler"
  filename         = data.archive_file.get_course.output_path
  source_code_hash = data.archive_file.get_course.output_base64sha256
}

data "archive_file" "get_course" {
  type        = "zip"
  source_file = "${path.module}/src/get_course/get_course.py"
  output_path = "${path.module}/src/get_course/get_course.zip"
}

resource "aws_lambda_function" "save_course" {
  function_name    = module.label_save_course.id
  role             = var.lambda_exec_role_arn
  runtime          = "python3.12"
  handler          = "save_course.lambda_handler"
  filename         = data.archive_file.save_course.output_path
  source_code_hash = data.archive_file.save_course.output_base64sha256
}

data "archive_file" "save_course" {
  type        = "zip"
  source_file = "${path.module}/src/save_course/save_course.py"
  output_path = "${path.module}/src/save_course/save_course.zip"
}

resource "aws_lambda_function" "update_course" {
  function_name    = module.label_update_course.id
  role             = var.lambda_exec_role_arn
  runtime          = "python3.12"
  handler          = "update_course.lambda_handler"
  filename         = data.archive_file.update_course.output_path
  source_code_hash = data.archive_file.update_course.output_base64sha256
}

data "archive_file" "update_course" {
  type        = "zip"
  source_file = "${path.module}/src/update_course/update_course.py"
  output_path = "${path.module}/src/update_course/update_course.zip"
}

resource "aws_lambda_function" "delete_course" {
  function_name    = module.label_delete_course.id
  role             = var.lambda_exec_role_arn
  runtime          = "python3.12"
  handler          = "delete_course.lambda_handler"
  filename         = data.archive_file.delete_course.output_path
  source_code_hash = data.archive_file.delete_course.output_base64sha256
}

data "archive_file" "delete_course" {
  type        = "zip"
  source_file = "${path.module}/src/delete_course/delete_course.py"
  output_path = "${path.module}/src/delete_course/delete_course.zip"
}
