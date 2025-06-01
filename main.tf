terraform {
  backend "s3" {
    bucket         = "lpnu-zakhar-backend"
    key            = "envs/dev/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "lpnu-zakhar-backend"
    encrypt        = true
  }
}
