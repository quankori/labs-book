data "terraform_remote_state" "terraform_common_s3_state" {
  backend = "s3"
  config = {
    bucket  = "prj-dev-backend-terraform"
    key     = "common/terraform.tfstate"
    region  = "ap-southeast-1"
    profile = "kori-admin"
  }
}

data "aws_acm_certificate" "prj_acm_cert_dev" {
  domain = data.terraform_remote_state.terraform_common_s3_state.outputs.prj_acm_dev_domain
}

data "aws_vpc" "prj_vpc_dev" {
  id = data.terraform_remote_state.terraform_common_s3_state.outputs.prj_vpc_dev_id
}

data "aws_subnet" "prj_pubsub01_dev" {
  id = data.terraform_remote_state.terraform_common_s3_state.outputs.prj_subpub1_dev_id
}

data "aws_subnet" "prj_pubsub02_dev" {
  id = data.terraform_remote_state.terraform_common_s3_state.outputs.prj_subpub2_dev_id
}

data "aws_subnet" "prj_prisub01_dev" {
  id = data.terraform_remote_state.terraform_common_s3_state.outputs.prj_subpri1_dev_id
}

data "aws_subnet" "prj_prisub02_dev" {
  id = data.terraform_remote_state.terraform_common_s3_state.outputs.prj_subpri2_dev_id
}
