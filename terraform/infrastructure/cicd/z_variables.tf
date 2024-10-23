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

variable "tags" {
  type = map(string)
  default = {
    environment = "develop"
    project     = "prj"
    env         = "dev"
    manager     = "terraform"
  }
}

variable "ecr_image" {
  type    = string
  default = "498907343309.dkr.ecr.ap-southeast-1.amazonaws.com/prj-ecr-dev:latest"
}

variable "arn_codestar" {
  type    = string
  default = "arn:aws:codestar-connections:ap-southeast-1:498907343309:connection/31a8fd7a-1b2b-4880-9aa3-77b14aa1cb2b"
}

variable "task_def" {
  type    = string
  default = "taskdef.json"
}

variable "appspec" {
  type    = string
  default = "appspec.yml"
}
