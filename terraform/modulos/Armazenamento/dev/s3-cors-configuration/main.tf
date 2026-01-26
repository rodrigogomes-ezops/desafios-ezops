resource "aws_s3_bucket_cors_configuration" "this" {
  bucket = var.bucket_name

  dynamic "cors_rule" {
    for_each = var.cors_rules
    content {
      allowed_origins = cors_rule.value.allowed_origins
      allowed_methods = cors_rule.value.allowed_methods
      allowed_headers = try(cors_rule.value.allowed_headers, ["*"])
      expose_headers  = try(cors_rule.value.expose_headers, [])
      max_age_seconds = try(cors_rule.value.max_age_seconds, 3000)
    }
  }
}
