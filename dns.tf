resource "aws_acm_certificate" "this" {
  provider    = aws.us-east-1
  domain_name = var.domain_name
  subject_alternative_names = [
    "*.${var.domain_name}",
  ]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route_53_zone_id
}

resource "aws_acm_certificate_validation" "this" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}


resource "aws_route53_record" "domain_name" {
  type    = "A"
  zone_id = var.route_53_zone_id
  name    = var.domain_name

  alias {
    name = aws_cloudfront_distribution.this.domain_name
    //HardCoded value for CloudFront
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}
