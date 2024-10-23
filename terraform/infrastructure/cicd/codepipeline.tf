resource "aws_codepipeline" "prj_codepipeline_dev" {
  name     = "${var.project_name}-pipeline-${var.project_env}"
  role_arn = aws_iam_role.prj_codepipeline_role_dev.arn
  artifact_store {
    location = aws_s3_bucket.prj_s3_artifact_pipeline_dev.bucket
    type     = "S3"
  }

  stage {
    name = "SourceGit"
    action {
      name             = "SourceGit"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["Source"]
      configuration = {
        ConnectionArn        = var.arn_codestar
        BranchName           = "deploy"
        OutputArtifactFormat = "CODE_ZIP"
        FullRepositoryId     = "quankori/terraform-ecs"
      }
    }
  }

  stage {
    name = "BuildNode"
    action {
      name             = "BuildAPI"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["Source"]
      output_artifacts = ["BuildAPI"]
      configuration = {
        ProjectName = aws_codebuild_project.prj_codebuild_api_dev.name
      }
    }
  }

  stage {
    name = "BuildCMS"
    action {
      name             = "Build_Deploy_Landing"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["Source"]
      output_artifacts = ["BuildLand"]
      configuration = {
        ProjectName = aws_codebuild_project.prj_codebuild_landing_dev.name
      }
    }
  }

  stage {
    name = "DeployECS"
    action {
      name            = "DeployAction"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      version         = "1"
      input_artifacts = ["BuildAPI"]
      configuration = {
        ApplicationName                = aws_codedeploy_app.prj_codepdeploy_api_ecs_dev.name
        DeploymentGroupName            = aws_codedeploy_deployment_group.prj_codepdeploy_api_ecs_grp_dev.deployment_group_name
        TaskDefinitionTemplateArtifact = "BuildAPI"
        TaskDefinitionTemplatePath     = var.task_def
        AppSpecTemplateArtifact        = "BuildAPI"
        AppSpecTemplatePath            = var.appspec
      }
    }
  }
}
