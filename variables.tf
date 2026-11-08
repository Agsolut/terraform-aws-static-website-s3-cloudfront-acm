variable "domain_name" {
  type        = string
  description = "Domain name for website, used for all resources"
}


variable "manage_route53" {
  type        = bool
  default     = true
  description = "Whether to manage Route 53 records. Set to false if using external DNS provider."
}

variable "route_53_zone_id" {
  type        = string
  default     = ""
  description = "Route 53 zone id for domain. Required when manage_route53 is true."
}

variable "cloudfront_price_class" {
  type        = string
  default     = "PriceClass_100" # Only US,Canada,Europe
  description = "CloudFront distribution price class"
}

# All values for the TTL are important when uploading static content that changes
# https://stackoverflow.com/questions/67845341/cloudfront-s3-etag-possible-for-cloudfront-to-send-updated-s3-object-before-t
variable "cloudfront_min_ttl" {
  type        = number
  default     = 0
  description = "The minimum TTL for the cloudfront cache"
}

variable "cloudfront_default_ttl" {
  type        = number
  default     = 86400
  description = "The default TTL for the cloudfront cache"
}

variable "cloudfront_max_ttl" {
  type        = number
  default     = 31536000
  description = "The maximum TTL for the cloudfront cache"
}

variable "cloudfront_minimum_protocol_version" {
  type        = string
  description = "The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections."
  default     = "TLSv1.2_2019"
}

variable "deploy_sample_content" {
  type        = bool
  default     = false
  description = "Deploy sample content to show website working?"
}

variable "cloudfront_default_root_object" {
  type        = string
  description = "Default root object for cloudfront. Need to also provide custom error response if changing from default"
  default     = "index.html"
}

variable "s3_bucket_custom_name" {
  type        = string
  description = "Any non-empty string here will replace default name of bucket `var.domain_name`"
  default     = ""
}

variable "s3_bucket_versioning" {
  type        = bool
  description = "Apply versioning to S3 bucket?"
  default     = false
}

variable "s3_bucket_public_access_block" {
  type        = bool
  description = "Apply public access block to S3 bucket?"
  default     = true
}

variable "cloudfront_custom_error_responses" {
  type = list(object({
    error_code            = number
    response_code         = number
    error_caching_min_ttl = number
    response_page_path    = string
  }))
  description = "See https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/GeneratingCustomErrorResponses.html"
  default = [
    {
      error_code            = 403
      response_code         = 404
      error_caching_min_ttl = 10
      response_page_path    = "/index.html"
    },
    {
      error_code            = 404
      response_code         = 404
      error_caching_min_ttl = 10
      response_page_path    = "/index.html"
    }
  ]
}

# A private S3 origin (which OAC requires) serves objects by exact key, and
# `cloudfront_default_root_object` only resolves `/`. A multi-page static
# export therefore needs a viewer-request function to map directory URLs like
# `/fr/legal/` onto `/fr/legal/index.html`. Defaults to none, so distributions
# that do not need one are unchanged.
variable "cloudfront_function_associations" {
  type = list(object({
    event_type   = string
    function_arn = string
  }))
  description = "CloudFront Functions to attach to the default cache behaviour. At most one per event type."
  default     = []

  validation {
    condition = alltrue([
      for a in var.cloudfront_function_associations :
      contains(["viewer-request", "viewer-response"], a.event_type)
    ])
    error_message = "event_type must be either 'viewer-request' or 'viewer-response'."
  }

  validation {
    condition = length(distinct([
      for a in var.cloudfront_function_associations : a.event_type
    ])) == length(var.cloudfront_function_associations)
    error_message = "CloudFront allows at most one function per event type."
  }
}

# Extra origins and path-based cache behaviours, e.g. routing `/api/*` on the same
# domain to an API Gateway. Without these, anything added to the distribution by
# hand is removed on the next apply. Both default to `[]`, so existing
# configurations plan unchanged.
variable "additional_origins" {
  type = list(object({
    origin_id                = string
    domain_name              = string
    origin_path              = optional(string, "")
    http_port                = optional(number, 80)
    https_port               = optional(number, 443)
    origin_protocol_policy   = optional(string, "https-only")
    origin_ssl_protocols     = optional(list(string), ["TLSv1.2"])
    origin_read_timeout      = optional(number, 30)
    origin_keepalive_timeout = optional(number, 5)
    connection_attempts      = optional(number, 3)
    connection_timeout       = optional(number, 10)
  }))
  description = "Additional custom (non-S3) origins, e.g. an API Gateway. Referenced from ordered_cache_behaviors by origin_id."
  default     = []
}

variable "ordered_cache_behaviors" {
  type = list(object({
    path_pattern               = string
    target_origin_id           = string
    allowed_methods            = list(string)
    cached_methods             = list(string)
    viewer_protocol_policy     = optional(string, "redirect-to-https")
    compress                   = optional(bool, true)
    cache_policy_id            = string
    origin_request_policy_id   = optional(string)
    response_headers_policy_id = optional(string)
  }))
  description = "Path-based cache behaviours evaluated before the default (S3) behaviour, in list order. Uses cache policies (no legacy forwarded_values)."
  default     = []
}
