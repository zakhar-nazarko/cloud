module "table_authors" {
  source  = "./modules/dynamodb"
  context = module.label.context
  name    = "authors"
}

module "lambda" {
  source                = "./modules/lambda"
  context               = module.label.context
  lambda_exec_role_arn = module.iam.lambda_exec_role_arn
}

module "iam" {
  source = "./modules/iam"
  aws_caller_identity = data.aws_caller_identity.current.account_id
  aws_region = var.aws_region
}