variable "disable_index_html" {
  default     = false
  description = "True to suppress the S3 object for the `index_html_source` parameter"
  type        = bool
}

variable "domain" {
  description = "The domain name for the website"
  type        = string
}

variable "index_html_source" {
  default     = null
  description = "The source for the root index.html file"
  type        = string
}

variable "site_name" {
  default     = "www"
  description = "The site name for the website"
  type        = string
}
