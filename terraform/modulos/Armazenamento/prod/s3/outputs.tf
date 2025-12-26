output "bucket_name" {
  description = "Nome do bucket S3"
  value       = aws_s3_bucket.this.bucket
}

output "bucket_regional_domain_name" {
  description = "Regional domain name do bucket S3"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "bucket_arn" {
  description = "ARN do bucket S3"
  value       = aws_s3_bucket.this.arn
}
