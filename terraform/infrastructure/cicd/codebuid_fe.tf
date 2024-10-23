resource "aws_codebuild_project" "prj_codebuild_landing_dev" {
  name           = "${var.project_name}-codebuild-landing-project-${var.project_env}"
  service_role   = aws_iam_role.prj_codebuild_role_cd_dev.arn
  build_timeout  = 15
  tags           = var.tags
  source_version = "develop"

  source {
    type            = "GITHUB"
    location        = "https://github.com/quankori/terraform-ecs.git"
    git_clone_depth = 1
    buildspec       = "codebuild/web/buildspec.yml"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    environment_variable {
      name  = "S3_FRONT"
      value = data.terraform_remote_state.terraform_common_s3_state.outputs.prj_s3_fe_dev_bucket
    }
    environment_variable {
      name  = "CF_ID"
      value = data.terraform_remote_state.terraform_common_s3_state.outputs.prj_cloudfront_fe_dev_id
    }
    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }
  }

  artifacts {
    type                = "S3"
    location            = aws_s3_bucket.prj_s3_artifact_pipeline_dev.bucket
    packaging           = "ZIP"
    name                = "BuildLand"
    encryption_disabled = true
  }

  cache {
    type = "NO_CACHE"
  }
}
