resource "aws_cloudfront_distribution" "prj_cloudfront_api_dev" {

  enabled     = true
  aliases     = ["api.${var.project_domain}"]
  price_class = "PriceClass_100"
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.prj_s3_logs_dev.bucket_regional_domain_name
    prefix          = "${var.project_name}-api-ecs-${var.project_env}"
  }

  #   web_acl_id = aws_wafv2_web_acl.prj_wafv2_cloudfront_acl_dev.arn

  origin {
    domain_name = data.terraform_remote_state.terraform_api-ecs_s3_state.outputs.prj_api_ecs_lb_dev_dn
    origin_id   = "ELB-${var.project_name}-api-ecs-lb-${var.project_env}"
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["TLSv1"]
      origin_keepalive_timeout = 5
      origin_read_timeout      = 30
    }
  }

  default_cache_behavior {
    target_origin_id       = "ELB-${var.project_name}-api-ecs-lb-${var.project_env}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["POST", "HEAD", "PATCH", "DELETE", "PUT", "GET", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = true
      headers      = ["*"]
      cookies {
        forward = "all"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.prj_acm_dev.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }
  tags = {
    Name = "${var.project_name}-cloudfront-api-${var.project_env}"
  }
  depends_on = [aws_acm_certificate.prj_acm_dev]
}
