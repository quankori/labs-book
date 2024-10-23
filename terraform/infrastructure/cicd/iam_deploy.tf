resource "aws_iam_role" "prj_codedeploy_role_dev" {
  name = "${var.project_name}-codedeploy-role-${var.project_env}"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "codedeploy.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "prj_codedeploy_ssm_plc_dev" {
  name        = "CodeDeploySSMPolicy"
  description = "Policy allowing CodeDeploy to access SSM Parameter Store"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:*",
          "ssm:*",
          "kms:*",
          "lambda:InvokeFunction"
        ],
        "Resource" : [
          "arn:aws:ssm:${var.aws_region}:${var.project_account_id}:parameter/*",
          "arn:aws:kms:${var.aws_region}:${var.project_account_id}:key/*",
          "arn:aws:lambda:*",
          "arn:aws:s3:::${aws_s3_bucket.prj_s3_artifact_pipeline_dev.id}",
          "arn:aws:s3:::${aws_s3_bucket.prj_s3_artifact_pipeline_dev.id}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "prj_codedeploy_plc_atc_dev" {
  role       = aws_iam_role.prj_codedeploy_role_dev.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_iam_role_policy_attachment" "prj_codedeploy_plc_atc2_dev" {
  role       = aws_iam_role.prj_codedeploy_role_dev.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

resource "aws_iam_role_policy_attachment" "prj_codedeploy_plc_atc3_dev" {
  role       = aws_iam_role.prj_codedeploy_role_dev.name
  policy_arn = aws_iam_policy.prj_codedeploy_ssm_plc_dev.arn
}
