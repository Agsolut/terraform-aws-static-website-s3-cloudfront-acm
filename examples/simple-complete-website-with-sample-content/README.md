# simple-complete-website-with-sample-content

This deploys a complete example website with sample content. Non specific-regional-mandated resources are deployed to eu-west-1

## Requirements

| Name                                                                     | Version   |
| ------------------------------------------------------------------------ | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.2.8  |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 4.29.0 |

## Providers

No providers.

## Modules

| Name                                                                                                                                | Source                                       | Version |
| ----------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- | ------- |
| <a name="module_static-website-s3-cloudfront-acm"></a> [static-website-s3-cloudfront-acm](#module_static-website-s3-cloudfront-acm) | agsolut/static-website-s3-cloudfront-acm/aws | n/a     |

## Resources

No resources.

## Inputs

| Name                                                               | Description                                     | Type     | Default       | Required |
| ------------------------------------------------------------------ | ----------------------------------------------- | -------- | ------------- | :------: |
| <a name="input_domain_name"></a> [domain_name](#input_domain_name) | Domain name for website, used for all resources | `string` | n/a           |   yes    |
| <a name="input_region"></a> [region](#input_region)                | Region for our region-optional resources        | `string` | `"eu-west-1"` |    no    |

## Outputs

| Name                                                                                                              | Description |
| ----------------------------------------------------------------------------------------------------------------- | ----------- |
| <a name="output_acm_certificate_id"></a> [acm_certificate_id](#output_acm_certificate_id)                         | n/a         |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront_distribution_id](#output_cloudfront_distribution_id) | n/a         |
| <a name="output_cloudfront_domain_name"></a> [cloudfront_domain_name](#output_cloudfront_domain_name)             | n/a         |
| <a name="output_s3_bucket_arn"></a> [s3_bucket_arn](#output_s3_bucket_arn)                                        | n/a         |
| <a name="output_s3_bucket_id"></a> [s3_bucket_id](#output_s3_bucket_id)                                           | n/a         |
| <a name="output_website_url"></a> [website_url](#output_website_url)                                              | n/a         |
