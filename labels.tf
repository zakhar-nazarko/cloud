module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  label_order = var.label_order
  delimiter = "-"

}

module "backend_labels" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace = "lpnu"
  stage     = "dev"
  name      = "zakhar-backend"
  tags = {
    ManagedBy = "Terraform"
  }
}
