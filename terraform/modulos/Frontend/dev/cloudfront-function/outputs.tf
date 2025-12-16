output "function_arn" {
  value       = aws_cloudfront_function.this.arn
  description = "ARN da CloudFront Function"
}
