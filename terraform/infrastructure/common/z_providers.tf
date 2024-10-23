provider "aws" {
  region = var.aws_region
}

// Because some service just only avaliable on region us-east-1 
// and we will define it with alias
provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}