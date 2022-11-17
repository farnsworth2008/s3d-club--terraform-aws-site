variable "acm_arn" {
  default = null
  type    = string

  description = <<-EOT
    An ACM ARN.
    EOT
}

variable "cloudfront_price_class" {
  default = "PriceClass_100"
  type    = string

  description = <<-EOT
    The Cloudfront PriceClass.
    EOT
}

variable "default_root_object" {
  default = "index.html"
  type    = string

  description = <<-EOT
    The Cloudfront Default Root Object.
    EOT
}

variable "domain" {
  type = string

  description = <<-EOT
    The `domain` name.
    EOT
}

variable "enable_ip6" {
  default = false
  type    = bool

  description = <<-EOT
    An option to enable IP6 addressing.
    EOT
}

variable "enable_waf" {
  default = false
  type    = bool

  description = <<-EOT
    An option to enable AWS WAF resources.
    EOT
}

variable "favicon" {
  default = "DEFAULT"
  type    = string

  description = <<-EOT
    The favicon path or `null` to disable it.
    EOT
}

variable "ip_blacklist" {
  default = null
  type    = list(string)

  description = <<-EOT
    The IP blacklist.    
    EOT
}

variable "ip_whitelist" {
  default = null
  type    = list(string)

  description = <<-EOT
    The IP whitelist.
    EOT
}

variable "kms_key_arn" {
  type = string

  description = <<-EOT
    KMS key ARN.
    EOT
}

variable "name" {
  default = "www"
  type    = string

  description = <<-EOT
    The subdomain for Cloudfront.
    EOT
}

variable "single_page_application" {
  default = true
  type    = bool

  description = <<-EOT
    True if this is a single page application site
    EOT
}

variable "subject_alternative_names" {
  default = []
  type    = list(string)

  description = <<-EOT
    A subject alternative name.
    EOT
}

variable "tags" {
  type = map(string)

  description = <<-EOT
    Tags for resources.
    EOT
}

variable "waf_arn" {
  default = null
  type    = string

  description = <<-EOT
    The WAF ARN.
    EOT
}

variable "waf_redirects" {
  default = null
  type    = map(string)

  description = <<-EOT
    A list of redirects for the WAF.
    EOT
}

variable "www_bucket" {
  default = null
  type    = string

  description = <<-EOT
    The WWW Bucket name or null to use a random name.
    EOT
}
