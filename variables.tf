variable "disable_favicon" {
  default     = false
  description = "True to suppress the S3 object for the `favicon_source` parameter"
  type        = bool
}

variable "disable_index_html" {
  default     = false
  description = "True to suppress the S3 object for the `index_html_source` parameter"
  type        = bool
}

variable "domain" {
  description = "The domain name for the website"
  type        = string
}

variable "favicon_source" {
  default     = null
  description = "The source for the root favicon.ico resource"
  type        = string
}

variable "index_html_source" {
  default     = null
  description = "The source for the root index.html resource"
  type        = string
}

variable "site_name" {
  default     = "www"
  description = "The site name for the website"
  type        = string
}
