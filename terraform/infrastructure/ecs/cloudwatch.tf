resource "aws_cloudwatch_log_group" "prj_api_ecs_loggrp_dev" {
  name              = "${var.project_name}-api-ecs-logs-${var.project_env}"
  retention_in_days = 30
}
