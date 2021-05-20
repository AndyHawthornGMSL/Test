variable region {}
variable env {}
variable deployment-role {}

provider "aws" {
  version = "~> 3.0"
  region  = var.region

  assume_role {
    role_arn     = var.deployment-role
    session_name = "DeploymentAccess"
    external_id  = "terraform"
  }
}

locals {
  common_tags = {
    env = var.env
  }
}
