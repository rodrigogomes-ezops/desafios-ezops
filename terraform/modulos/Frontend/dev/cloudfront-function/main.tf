resource "aws_cloudfront_function" "this" {
  name    = var.function_name
  runtime = var.function_runtime
  publish = var.publish
  code    = var.function_code
}
