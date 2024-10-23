variable "cidr_public_subnet" {
  type    = string
  default = "10.11.13.0/24"
}

variable "cidr_public_subnet2" {
  type    = string
  default = "10.11.14.0/24"
}

variable "cidr_private_subnet" {
  type    = string
  default = "10.11.12.0/24"
}

variable "cidr_private_subnet2" {
  type    = string
  default = "10.11.15.0/24"
}

variable "cidr_vpc" {
  type    = string
  default = "10.11.0.0/16"
}

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

variable "project_domain" {
  type    = string
  default = "quankori.xyz"
}

variable "project_account_id" {
  type    = string
  default = "498907343309"
}

variable "ec2_linux_ami" {
  type    = string
  default = "ami-0a481e6d13af82399"
}
