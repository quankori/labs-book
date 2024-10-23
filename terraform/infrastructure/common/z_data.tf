data "terraform_remote_state" "terraform_api-ecs_s3_state" {
  backend = "s3"
  config = {
    bucket  = "prj-dev-backend-terraform"
    key     = "ecs/terraform.tfstate"
    region  = "ap-southeast-1"
    profile = "kori-admin"
  }
}
