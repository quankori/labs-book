resource "aws_s3_bucket" "prj_s3_fe_dev" {
  bucket = "${var.project_name}-fe-${var.project_env}"
  tags = {
    Name = "${var.project_name}-fe-${var.project_env}"
  }
}

resource "aws_s3_bucket_ownership_controls" "prj_s3_fe_ownctl_dev" {
  bucket = aws_s3_bucket.prj_s3_fe_dev.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "prj_s3_fe_pubacs_dev" {
  bucket = aws_s3_bucket.prj_s3_fe_dev.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

// Policy cloudfront to access s3
resource "aws_cloudfront_origin_access_identity" "prj_oai_fe_dev" {
  comment = "Access identity for ${var.project_name}-fe-${var.project_env} S3 bucket from Cloudfront"
}

resource "aws_s3_bucket_acl" "prj_s3_fe_acl_dev" {
  depends_on = [aws_s3_bucket_ownership_controls.prj_s3_fe_ownctl_dev]
  bucket     = aws_s3_bucket.prj_s3_fe_dev.id
  acl        = "private"
}

resource "aws_s3_bucket_policy" "prj_oai_policy_fe_dev" {
  bucket = aws_s3_bucket.prj_s3_fe_dev.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Sid" : "Statement01",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${var.project_account_id}:root"
        },
        "Action" : "s3:*",
        "Resource" : [
          "${aws_s3_bucket.prj_s3_fe_dev.arn}/*"
        ]
      },
      {
        "Sid"    = "Allow cloudfront access to the bucket",
        "Effect" = "Allow",
        "Principal" = {
          "AWS" = "${aws_cloudfront_origin_access_identity.prj_oai_fe_dev.iam_arn}"
        },
        "Action"   = "s3:GetObject",
        "Resource" = "${aws_s3_bucket.prj_s3_fe_dev.arn}/*"
      }
    ]
  })
}

output "prj_s3_fe_dev_bucket" {
  value = aws_s3_bucket.prj_s3_fe_dev.bucket
}
