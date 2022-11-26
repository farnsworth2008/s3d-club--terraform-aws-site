output "domain" {
  value = var.domain

  description = <<-END
    The site's Domain.
    END
}

output "s3_bucket" {
  value = local.www_bucket

  description = <<-END
    The site's S3 bucket.
    END
}

output "waf_arn" {
  value = local.waf_arn

  description = <<-END
    The WAF ARN.
    END
}

output "website" {
  value = local.website

  description = <<-END
    The URL for the website.
    END
}
