output "oai_id" {
  description = "ID da Origin Access Identity"
  value       = aws_cloudfront_origin_access_identity.this.id
}

output "oai_cloudfront_access_identity_path" {
  description = "Caminho de identidade do CloudFront"
  value       = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
}

output "oai_s3_canonical_user_id" {
  description = "Canonical user ID utilizado no S3 bucket policy"
  value       = aws_cloudfront_origin_access_identity.this.s3_canonical_user_id
}
