variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "project_name" {
  type    = string
  default = "prj"
}

variable "project_env" {
  type    = string
  default = "dev"
}

variable "project_account_id" {
  type    = string
  default = "498907343309"
}

variable "cidr_vpc" {
  type    = string
  default = "10.11.0.0/16"
}

variable "ecr_image" {
  type    = string
  default = "498907343309.dkr.ecr.ap-southeast-1.amazonaws.com/prj-ecr-dev:latest"
}
