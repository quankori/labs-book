resource "aws_codedeploy_app" "prj_codepdeploy_api_ecs_dev" {
  name             = "${var.project_name}-codedeploy-api-ecs-${var.project_env}"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "prj_codepdeploy_api_ecs_grp_dev" {
  app_name               = aws_codedeploy_app.prj_codepdeploy_api_ecs_dev.name
  deployment_group_name  = "${var.project_name}-codedeploy-api-ecs-grp-${var.project_env}"
  service_role_arn       = aws_iam_role.prj_codedeploy_role_dev.arn
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  ecs_service {
    cluster_name = data.terraform_remote_state.terraform_api-ecs_s3_state.outputs.prj_api_ecs_cluster_dev_name
    service_name = data.terraform_remote_state.terraform_api-ecs_s3_state.outputs.prj_api_ecs_svc_dev_name
  }
  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 0
    }
  }
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
  load_balancer_info {
    target_group_pair_info {
      test_traffic_route {
        listener_arns = [data.terraform_remote_state.terraform_api-ecs_s3_state.outputs.prj_api_ecs_lns_http_dev_arn]
      }
      prod_traffic_route {
        listener_arns = [data.terraform_remote_state.terraform_api-ecs_s3_state.outputs.prj_api_ecs_lns_https_dev_arn]
      }
      target_group {
        name = data.terraform_remote_state.terraform_api-ecs_s3_state.outputs.prj_api_ecs_trg_dev_name
      }
      target_group {
        name = data.terraform_remote_state.terraform_api-ecs_s3_state.outputs.prj_api_ecs_trg2_dev_name
      }
    }
  }
}
