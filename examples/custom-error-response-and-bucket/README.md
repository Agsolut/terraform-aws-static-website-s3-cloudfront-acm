# custom-error-response-and-bucket

This deploys a complete example website with sample content. Non specific-regional-mandated resources are deployed to eu-west-1

A custom bucket name is specified based on the deployed aws region and account id

A custom 404 error page linking back to the domain homepage is created outboard of the module and referenced for custom error responses for 403 and 404 errors

## Requirements

| Name                                                                     | Version   |
| ------------------------------------------------------------------------ | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.2.8  |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 4.29.0 |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | 4.31.0  |

## Modules

| Name                                                                                                                                | Source | Version |
| ----------------------------------------------------------------------------------------------------------------------------------- | ------ | ------- |
| <a name="module_static-website-s3-cloudfront-acm"></a> [static-website-s3-cloudfront-acm](#module_static-website-s3-cloudfront-acm) | ../../ | n/a     |

## Resources

| Name                                                                                                                          | Type        |
| ----------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_s3_object.custom_error_page](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object)      | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name                                                                                                                                 | Description                                     | Type          | Default                                                                                                                                                                                                                                                                                    | Required |
| ------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :------: |
| <a name="input_cloudfront_custom_error_responses"></a> [cloudfront_custom_error_responses](#input_cloudfront_custom_error_responses) | n/a                                             | `list(any)`   | <pre>[<br> {<br> "error_caching_min_ttl": 10,<br> "error_code": 403,<br> "response_code": 404,<br> "response_page_path": "/404.html"<br> },<br> {<br> "error_caching_min_ttl": 10,<br> "error_code": 404,<br> "response_code": 404,<br> "response_page_path": "/404.html"<br> }<br>]</pre> |    no    |
| <a name="input_domain_name"></a> [domain_name](#input_domain_name)                                                                   | Domain name for website, used for all resources | `string`      | n/a                                                                                                                                                                                                                                                                                        |   yes    |
| <a name="input_region"></a> [region](#input_region)                                                                                  | Region for our region-optional resources        | `string`      | `"eu-west-1"`                                                                                                                                                                                                                                                                              |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                                        | Provider default tags, applied to all resources | `map(string)` | <pre>{<br> "managed_by_terraform": true,<br> "terraform_module": "agsolut/static-website-s3-cloudfront-acm/aws"<br>}</pre>                                                                                                                                                                 |    no    |

## Outputs

| Name                                                                                                              | Description |
| ----------------------------------------------------------------------------------------------------------------- | ----------- |
| <a name="output_acm_certificate_id"></a> [acm_certificate_id](#output_acm_certificate_id)                         | n/a         |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront_distribution_id](#output_cloudfront_distribution_id) | n/a         |
| <a name="output_cloudfront_domain_name"></a> [cloudfront_domain_name](#output_cloudfront_domain_name)             | n/a         |
| <a name="output_s3_bucket_arn"></a> [s3_bucket_arn](#output_s3_bucket_arn)                                        | n/a         |
| <a name="output_s3_bucket_id"></a> [s3_bucket_id](#output_s3_bucket_id)                                           | n/a         |
| <a name="output_website_url"></a> [website_url](#output_website_url)                                              | n/a         |
