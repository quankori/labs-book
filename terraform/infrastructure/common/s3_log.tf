resource "aws_s3_bucket" "prj_s3_logs_dev" {
  bucket = "${var.project_name}-log-${var.project_env}"
  tags = {
    Name = "${var.project_name}-log-${var.project_env}"
  }
}

resource "aws_s3_bucket_ownership_controls" "prj_s3_logs_ownctl_dev" {
  bucket = aws_s3_bucket.prj_s3_logs_dev.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "prj_s3_logs_pubacs_dev" {
  bucket = aws_s3_bucket.prj_s3_logs_dev.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

// Policy cloudfront to access s3
resource "aws_cloudfront_origin_access_identity" "prj_oai_logs_dev" {
  comment = "Access identity for ${var.project_name}-logs-${var.project_env} S3 bucket from Cloudfront"
}

resource "aws_s3_bucket_acl" "prj_s3_logs_acl_dev" {
  depends_on = [aws_s3_bucket_ownership_controls.prj_s3_logs_ownctl_dev]
  bucket     = aws_s3_bucket.prj_s3_logs_dev.id
  acl        = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "prj_s3_logs_dev" {
  bucket = aws_s3_bucket.prj_s3_logs_dev.id
  rule {
    id = "RotateLogRule"
    filter {}
    status = "Enabled"
    transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"
    }
    transition {
      days          = 90
      storage_class = "GLACIER"
    }
    transition {
      days          = 180
      storage_class = "DEEP_ARCHIVE"
    }
    expiration {
      days = 365
    }
  }
}

output "prj_s3_logs_dev_bucket" {
  value = aws_s3_bucket.prj_s3_logs_dev.bucket_domain_name
}
