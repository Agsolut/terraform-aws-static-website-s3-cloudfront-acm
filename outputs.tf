output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.this.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.this.id
  description = "deprecated and will be removed - use `s3_bucket_id`"
}

output "s3_bucket_id" {
  value = aws_s3_bucket.this.id
}

output "acm_certificate_id" {
  value = aws_acm_certificate.this.id
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.this.arn
}

output "acm_certificate_validation_records" {
  description = "DNS validation records needed for ACM certificate. Add these to your DNS provider when manage_route53 is false."
  value = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      value  = dvo.resource_record_value
    }
  }
}

output "dns_records_for_cloudfront" {
  description = "DNS records to add to your DNS provider to point to CloudFront. Use when manage_route53 is false."
  value = {
    main_domain = {
      name   = var.domain_name
      type   = "CNAME"
      value  = aws_cloudfront_distribution.this.domain_name
      note   = "Point your domain to CloudFront. If using root domain, use ALIAS/ANAME record if supported by your DNS provider."
    }
    www_subdomain = can(regex("^[^.]+\\.[^.]+$", var.domain_name)) ? {
      name  = "www.${var.domain_name}"
      type  = "CNAME"
      value = aws_cloudfront_distribution.this.domain_name
      note  = "Point www subdomain to CloudFront"
    } : null
  }
}