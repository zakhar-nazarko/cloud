module "table_authors" {
  source  = "./modules/dynamodb"
  context = module.label.context
  name    = "authors"
}

module "lambda" {
  source                   = "./modules/lambda"
  lambda_exec_role_arn     = module.iam.lambda_exec_role_arn
  aws_api_gateway_rest_api = module.gateaway.aws_api_gateway_rest_api
}

module "iam" {
  source              = "./modules/iam"
  aws_caller_identity = data.aws_caller_identity.current.account_id
  aws_region          = var.aws_region
}

module "gateaway" {
  source                         = "./modules/gateaway"
  lambda_permissions             = module.lambda.lambda_permissions
  get_all_authors_invoke_arn     = module.lambda.get_all_authors_invoke_arn
  get_all_courses_invoke_arn     = module.lambda.get_all_courses_invoke_arn
  post_save_course_invoke_arn    = module.lambda.post_save_course_invoke_arn
  put_update_course_invoke_arn   = module.lambda.put_update_course_invoke_arn
  delete_course_by_id_invoke_arn = module.lambda.delete_course_by_id_invoke_arn
  get_course_by_id_invoke_arn    = module.lambda.get_course_by_id_invoke_arn
}

module "front" {
  source = "./modules/front"
}