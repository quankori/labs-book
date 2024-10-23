resource "aws_lb" "prj_api_ecs_lb_dev" {
  name            = "${var.project_name}-api-ecs-lb-${var.project_env}"
  subnets         = [data.aws_subnet.prj_pubsub01_dev.id, data.aws_subnet.prj_pubsub02_dev.id]
  security_groups = [aws_security_group.prj_el_sg_dev.id]
  tags = {
    Name = "${var.project_name}-aws-lb-${var.project_env}"
  }
}

resource "aws_lb_target_group" "prj_api_ecs_trg_dev" {
  name        = "${var.project_name}-api-ecs-trg-${var.project_env}"
  port        = "3000"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.prj_vpc_dev.id
  health_check {
    enabled = true
    path    = "/"
  }
}


resource "aws_lb_target_group" "prj_api_ecs_trg2_dev" {
  name        = "${var.project_name}-api-ecs-trg2-${var.project_env}"
  port        = "3000"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.prj_vpc_dev.id
  health_check {
    enabled = true
    path    = "/"
  }
}

resource "aws_lb_listener" "prj_api_ecs_lns_http_dev" {
  load_balancer_arn = aws_lb.prj_api_ecs_lb_dev.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "prj_api_ecs_lns_https_dev" {
  load_balancer_arn = aws_lb.prj_api_ecs_lb_dev.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.prj_acm_cert_dev.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prj_api_ecs_trg_dev.arn
  }
  lifecycle {
    ignore_changes = [default_action]
  }
}
output "prj_api_ecs_trg_dev_name" {
  value = aws_lb_target_group.prj_api_ecs_trg_dev.name
}

output "prj_api_ecs_trg2_dev_name" {
  value = aws_lb_target_group.prj_api_ecs_trg2_dev.name
}
output "prj_api_ecs_lns_https_dev_arn" {
  value = aws_lb_listener.prj_api_ecs_lns_https_dev.arn
}

output "prj_api_ecs_lns_http_dev_arn" {
  value = aws_lb_listener.prj_api_ecs_lns_http_dev.arn
}

output "prj_api_ecs_lb_dev_dn" {
  value = aws_lb.prj_api_ecs_lb_dev.dns_name
}
