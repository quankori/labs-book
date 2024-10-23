data "terraform_remote_state" "terraform_api-ecs_s3_state" {
  backend = "s3"
  config = {
    bucket  = "prj-dev-backend-terraform"
    key     = "ecs/terraform.tfstate"
    region  = "ap-southeast-1"
    profile = "kori-admin"
  }
}

data "terraform_remote_state" "terraform_common_s3_state" {
  backend = "s3"
  config = {
    bucket  = "prj-dev-backend-terraform"
    key     = "common/terraform.tfstate"
    region  = "ap-southeast-1"
    profile = "kori-admin"
  }
}

resource "aws_codestarconnections_connection" "prj_codestar_conn_dev" {
  name          = "${var.project_name}-codestar-conn-${var.project_env}"
  provider_type = "GitHub"
}
