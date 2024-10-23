resource "aws_cloudfront_function" "prj_cloudfront_fe_function_dev" {
  name    = "${var.project_name}-fe-function-${var.project_env}"
  comment = "Function to handle requests to cloudfront"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = <<-EOT
    function handler(event) {
      var request = event.request;
      var uri = request.uri;
      if (uri.endsWith('/')) {
        request.uri += 'index.html';
      } else if (!uri.includes('.')) {
        request.uri += '/index.html';
      }
      return request;
    }
  EOT

  lifecycle {
    ignore_changes = [code]
  }
}

resource "aws_cloudfront_distribution" "prj_cloudfront_fe_dev" {
  enabled     = true
  aliases     = ["${var.project_domain}", "www.${var.project_domain}"]
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
    prefix          = "${var.project_name}-fe-${var.project_env}"
  }

  origin {
    domain_name = aws_s3_bucket.prj_s3_fe_dev.bucket_regional_domain_name
    origin_id   = "S3-${var.project_name}-fe-${var.project_env}"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.prj_oai_fe_dev.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id       = "S3-${var.project_name}-fe-${var.project_env}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  ordered_cache_behavior {
    target_origin_id       = "S3-${var.project_name}-fe-${var.project_env}"
    viewer_protocol_policy = "redirect-to-https"
    path_pattern           = "/"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.prj_cloudfront_fe_function_dev.arn
    }
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.prj_acm_dev.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

  depends_on = [aws_acm_certificate.prj_acm_dev]
  tags = {
    Name = "${var.project_name}-cloudfront-fe-${var.project_env}"
  }
}

output "prj_cloudfront_fe_dev_id" {
  value = aws_cloudfront_distribution.prj_cloudfront_fe_dev.id
}
