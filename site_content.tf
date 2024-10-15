resource "aws_s3_object" "sample_index_html" {
  count        = var.deploy_sample_content == true ? 1 : 0
  bucket       = aws_s3_bucket.this.id
  key          = "index.html"
  source       = "${path.module}/site_content/index.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/site_content/index.html")
}
