data "aws_caller_identity" "this" {}

locals {
  account_id        = data.aws_caller_identity.this.account_id
  domain            = var.domain
  log_bucket        = "${local.account_id}-log"
  s3_origin_id      = "main"
  web_bucket        = "web-${local.account_id}"
  index_html_source = var.disable_index_html ? null : coalesce(var.index_html_source, "${path.module}/index.html")
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name               = "${var.site_name}.${local.domain}"
  subject_alternative_names = ["*.${local.domain}"]
  wait_for_validation       = true
  zone_id                   = aws_route53_zone.this.zone_id
}

resource "aws_route53_record" "this" {
  name    = var.site_name
  records = [aws_cloudfront_distribution.this.domain_name]
  ttl     = 300
  type    = "CNAME"
  zone_id = aws_route53_zone.this.zone_id
}

resource "aws_route53_zone" "this" {
  name = local.domain
}

resource "aws_s3_bucket" "logs" {
  bucket = local.log_bucket
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Action    = "s3:GetObject"
      Effect    = "Allow"
      Principal = "*"
      Resource  = "arn:aws:s3:::${local.web_bucket}/*"
      Sid       = "PublicReadGetObject"
    }]
  })
}

resource "aws_s3_bucket" "this" {
  bucket = local.web_bucket
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = local.web_bucket

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_acl" "this" {
  acl    = "private"
  bucket = aws_s3_bucket.this.id
}

resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "Managed by Terraform"
}

resource "aws_cloudfront_distribution" "this" {
  aliases             = ["${var.site_name}.${local.domain}"]
  default_root_object = "index.html"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_200"
  tags                = { Environment = "production" }

  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  logging_config {
    bucket = "${local.log_bucket}.s3.amazonaws.com"
  }

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = module.acm.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }
}

resource "aws_s3_object" "object" {
  count = local.index_html_source == null ? 0 : 1

  bucket       = local.web_bucket
  content_type = "text/html"
  etag         = filemd5(local.index_html_source)
  key          = "index.html"
  source       = local.index_html_source
}
