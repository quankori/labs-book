resource "aws_s3_bucket" "prj_s3_artifact_pipeline_dev" {
  bucket = "${var.project_name}-artifact-pipeline-${var.project_env}"
  tags   = var.tags
}

resource "aws_s3_bucket_policy" "prj_s3_artifact_pipeline_plc_dev" {
  bucket = aws_s3_bucket.prj_s3_artifact_pipeline_dev.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowLBAccessLogs",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.project_account_id}:root"
            },
            "Action": "s3:*",
            "Resource": [
              "arn:aws:s3:::${aws_s3_bucket.prj_s3_artifact_pipeline_dev.id}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "codepipeline.amazonaws.com"
            },
            "Action": [
              "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::${aws_s3_bucket.prj_s3_artifact_pipeline_dev.id}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "codebuild.amazonaws.com"
            },
            "Action": [
              "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::${aws_s3_bucket.prj_s3_artifact_pipeline_dev.id}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "codedeploy.amazonaws.com"
            },
            "Action": [
              "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::${aws_s3_bucket.prj_s3_artifact_pipeline_dev.id}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ecs.amazonaws.com"
            },
            "Action": [
              "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::${aws_s3_bucket.prj_s3_artifact_pipeline_dev.id}/*"
            ]
        }
    ]
}
EOF
}

resource "aws_s3_bucket_acl" "prj_s3_artifact_pipeline_acl_dev" {
  bucket     = aws_s3_bucket.prj_s3_artifact_pipeline_dev.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.prj_s3_artifact_pipeline_ownctl_dev]
}

resource "aws_s3_bucket_versioning" "prj_s3_artifact_pipeline_version_dev" {
  bucket = aws_s3_bucket.prj_s3_artifact_pipeline_dev.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "prj_s3_front_logs_pubacs_dev" {
  bucket                  = aws_s3_bucket.prj_s3_artifact_pipeline_dev.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "prj_s3_artifact_pipeline_ownctl_dev" {
  bucket = aws_s3_bucket.prj_s3_artifact_pipeline_dev.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

output "prj_s3_artifact_pipeline_dev_bucket" {
  value = aws_s3_bucket.prj_s3_artifact_pipeline_dev.bucket
}
