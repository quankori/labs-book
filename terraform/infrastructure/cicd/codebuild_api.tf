resource "aws_codebuild_project" "prj_codebuild_api_dev" {
  name           = "${var.project_name}-codebuild-api-project-${var.project_env}"
  service_role   = aws_iam_role.prj_codebuild_role_cd_dev.arn
  build_timeout  = 10
  tags           = var.tags
  source_version = "develop"

  source {
    type            = "GITHUB"
    location        = "https://github.com/quankori/terraform-ecs.git"
    git_clone_depth = 1
    buildspec       = "codebuild/api/buildspec.yml"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    environment_variable {
      name  = "ECR_URI"
      value = var.ecr_image
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
    name                = "BuildAPI"
    encryption_disabled = true
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }
}
