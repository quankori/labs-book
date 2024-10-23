resource "aws_ssm_parameter" "node_env" {
  name  = "NODE_ENV"
  type  = "String"
  value = "prod"
  lifecycle {
    ignore_changes = [value]
  }
}
