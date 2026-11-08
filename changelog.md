# Changelog

## 2.6

- New optional inputs `additional_origins` and `ordered_cache_behaviors` add
  custom origins and path-based cache behaviours (e.g. `/current/*` routed to an
  API Gateway on the same domain). Previously such routes had to be added by
  hand and were removed by the next apply. Both default to `[]`, so existing
  configurations plan unchanged.
- `required_version` raised to `>= 1.3.0` (optional object attributes).

## 2.5

- New optional input `cloudfront_function_associations` attaches CloudFront
  Functions to the default cache behaviour. A private S3 origin serves objects
  by exact key and `cloudfront_default_root_object` only resolves `/`, so a
  multi-page static export needs a viewer-request function to rewrite
  directory URLs (`/fr/legal/` -> `/fr/legal/index.html`). Defaults to `[]`,
  so existing configurations plan unchanged.

## 2.2

- Remove `aws_s3_bucket_acl` since [use is now deprecated](https://aws.amazon.com/about-aws/whats-new/2023/04/amazon-s3-security-best-practices-buckets-default/#:~:text=Amazon%20S3%20now%20applies%20two%20new%20default%20bucket%20security%20settings,applied%20to%20all%20AWS%20Regions.)

## 2.1

- Custom http error responses are now supported
- A new example is included demonstrating use of custom error responses and custom s3 bucket name
- Output `s3_bucket_name` is deprecated and will be removed in a future release - use `s3_bucket_id` instead. This corrects inconsistent naming only, the same resource and attribute is referenced in either case.

## 2.0

Release 2.0 moves from `aws_cloudfront_origin_access_identity` to `aws_cloudfront_origin_access_control` in accord with [AWS latest recommended practice](https://aws.amazon.com/blogs/networking-and-content-delivery/amazon-cloudfront-introduces-origin-access-control-oac/). 

## Upgrading from version 1.0.0 => 2.0.0

In the unlikely event that you wish to upgrade between versions without a full `destroy` and `apply`, it is possible to resolve the error
```terraform
│ Error: CloudFrontOriginAccessIdentityInUse: The CloudFront origin access identity is still being used.
```
with
```bash
terraform destroy -target module.static-website-s3-cloudfront-acm.aws_cloudfront_distribution.this
```
Note that this will also destroy the dependent resources
```terraform
module.static-website-s3-cloudfront-acm.aws_route53_record.domain_name
module.static-website-s3-cloudfront-acm.aws_s3_bucket_policy.this
```
And your website will be temporarily unavailable. Then do
```bash
terraform apply
```
to destroy the orphaned `aws_cloudfront_origin_access_identity` and restore the 'missing' resources.