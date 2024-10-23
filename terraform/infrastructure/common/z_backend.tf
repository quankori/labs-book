terraform {
  backend "s3" {
    bucket  = "prj-dev-backend-terraform"
    key     = "common/terraform.tfstate"
    region  = "ap-southeast-1"
    profile = "kori-admin"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.1"
    }
  }
  required_version = "~> 1.4.6"
}
