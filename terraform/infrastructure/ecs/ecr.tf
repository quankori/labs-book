resource "aws_ecr_repository" "prj_ecr_dev" {
  name                 = "${var.project_name}-ecr-${var.project_env}"
  image_tag_mutability = "MUTABLE"
  tags = {
    Name = "${var.project_name}-ecr-${var.project_env}"
  }
}

output "prj_ecr_dev_name" {
  value = aws_ecr_repository.prj_ecr_dev.name
}
