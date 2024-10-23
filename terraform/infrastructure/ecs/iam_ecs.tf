resource "aws_iam_role" "prj_api_ecs_role_exec_dev" {
  name                  = "${var.project_name}-api-ecs-role-exec-${var.project_env}"
  force_detach_policies = true
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "prj_api_ecs_plc_exec_dev" {
  name = "${var.project_name}-api-ecs-plc-exec-${var.project_env}"
  role = aws_iam_role.prj_api_ecs_role_exec_dev.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameters",
          "kms:Decrypt"
        ]
        Resource = [
          "arn:aws:ssm:${var.aws_region}:${var.project_account_id}:parameter/*",
          "arn:aws:kms:${var.aws_region}:${var.project_account_id}:key/*"
        ]
      }
    ]
  })
}


resource "aws_iam_role" "prj_api_ecs_role_task_dev" {
  name                  = "${var.project_name}-api-ecs-role-task-${var.project_env}"
  force_detach_policies = true
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}



resource "aws_iam_role_policy" "prj_api_ecs_plc_task_dev" {
  name = "${var.project_name}-api-ecs-plc-task-${var.project_env}"
  role = aws_iam_role.prj_api_ecs_role_task_dev.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = "*"
      }
    ]
  })
}
