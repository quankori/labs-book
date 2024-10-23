resource "aws_iam_role" "prj_codepipeline_role_dev" {
  name                  = "${var.project_name}-codepipeline-role-${var.project_env}"
  force_detach_policies = true
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "prj_codepipeline_plc_dev" {
  name        = "${var.project_name}-codepipeline-plc-${var.project_env}"
  description = "Policy for ECS Fargate pipelinement with Codepipeline"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowCodePipelineAccess",
        "Effect" : "Allow",
        "Action" : [
          "codebuild:*",
          "codepipeline:*",
          "codedeploy:*",
          "s3:*",
          "lambda:*"
        ],
        "Resource" : [
          "arn:aws:codebuild:*",
          "arn:aws:codepipeline:*",
          "arn:aws:codedeploy:*",
          "arn:aws:lambda:*",
          "arn:aws:s3:::${aws_s3_bucket.prj_s3_artifact_pipeline_dev.id}/*"
        ]
      },
      {
        "Sid" : "AllowRegisECSTask",
        "Effect" : "Allow",
        "Action" : [
          "ecs:RegisterTaskDefinition"
        ],
        "Resource" : [
          "*"
        ]
      },
      {
        "Sid" : "IamPassRole",
        "Effect" : "Allow",
        "Action" : [
          "iam:PassRole"
        ],
        "Resource" : [
          "arn:aws:iam::${var.project_account_id}:role/*"
        ]
      },
      {
        "Sid" : "UseCodestarConnnection",
        "Effect" : "Allow",
        "Action" : [
          "codestar-connections:*"
        ],
        "Resource" : [
          "${var.arn_codestar}"
        ]
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "prj_codepipeline_role_plc_atc_dev" {
  role       = aws_iam_role.prj_codepipeline_role_dev.name
  policy_arn = aws_iam_policy.prj_codepipeline_plc_dev.arn
}
