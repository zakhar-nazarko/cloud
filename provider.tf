terraform {
  backend "s3" {
    bucket         = "lpnu-dev-zakhar-backend"
    key            = "envs/dev/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "lpnu-dev-zakhar-backend"
    encrypt        = true
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.99.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}