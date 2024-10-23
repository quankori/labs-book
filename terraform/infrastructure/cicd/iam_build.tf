resource "aws_iam_role" "prj_codebuild_role_cd_dev" {
  name                  = "${var.project_name}-codebuild-role-cd-${var.project_env}"
  force_detach_policies = true
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "prj_api_ecs_plc_cd_dev" {
  name = "${var.project_name}-codebuild-plc-cd-${var.project_env}"
  role = aws_iam_role.prj_codebuild_role_cd_dev.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:${var.project_account_id}:log-group:*"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      },
      {
        Effect   = "Allow"
        Resource = "*"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:PutObject"
        ]
      },
      {
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::*"
        ]
        Action = "*"
      },
      {
        Effect   = "Allow"
        Resource = "*"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
      },
      {
        Effect   = "Allow"
        Resource = "arn:aws:codepipeline:*:${var.project_account_id}:*"
        Action   = ["codepipeline:StartPipelineExecution"]
      },
      {
        Effect   = "Allow"
        Resource = "*"
        Action   = ["ecs:*"]
      },
      {
        Effect   = "Allow"
        Resource = "*"
        Action   = ["iam:PassRole"]
      },
      {
        Effect   = "Allow"
        Resource = "arn:aws:ssm:*:${var.project_account_id}:parameter/*"
        Action   = ["ssm:GetParameters"]
      },
      {
        Effect   = "Allow"
        Resource = "*"
        Action   = ["cloudfront:CreateInvalidation"]
      },
      {
        Effect   = "Allow"
        Resource = "*"
        Action   = ["codebuild:*"]
      },
      {
        Effect   = "Allow"
        Resource = "*"
        Action   = ["codepipeline:*"]
      },
      {
        Effect   = "Allow"
        Resource = "*"
        Action   = ["cloudfront:CreateInvalidation"]
      },
      {
        Effect   = "Allow"
        Resource = "*"
        Action   = ["lambda:*"]
      },
      {
        Effect   = "Allow",
        Resource = ["${var.arn_codestar}"],
        Action   = ["codestar-connections:*"]
      }
    ]
  })
}
