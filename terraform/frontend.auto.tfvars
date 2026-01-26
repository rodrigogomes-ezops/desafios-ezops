#######################################################################################################################
# Frontend - S3 e CloudFront #########################################################################################
# ---------------------------------------------------------------------------------------------------------------------

#######################
#### S3 Bucket ####
#######################

s3_bucket_name      = "rodrigo-ezops-frontend-bucket"  # Ajuste com um nome único
s3_environment       = "test"
s3_enable_versioning = false
s3_enable_encryption = true

# Política do bucket para permitir acesso apenas via CloudFront OAI
# Será configurada automaticamente quando o CloudFront OAI for criado
s3_bucket_policy_json = null  # Será configurado dinamicamente

tags_s3 = {
  Name        = "RODRIGO-S3-FRONTEND"
  Owner       = "Rodrigo Gomes"
  Project     = "Desafios EZOps"
  Environment = "Test"
  ManagedBy   = "Terraform"
}

#######################
#### CloudFront OAI ####
#######################

cloudfront_oai_comment = "Origin Access Identity para acesso ao S3 bucket do frontend"

tags_cloudfront_oai = {
  Name        = "RODRIGO-CLOUDFRONT-OAI"
  Owner       = "Rodrigo Gomes"
  Project     = "Desafios EZOps"
  Environment = "Test"
  ManagedBy   = "Terraform"
}

#######################
#### CloudFront Distribution ####
#######################

cloudfront_comment             = "CloudFront Distribution para frontend"
cloudfront_default_root_object  = "index.html"
cloudfront_price_class         = "PriceClass_All"
# cloudfront_aliases             = ["rodrigo-testes.ezopscloud.co"]
cloudfront_aliases             = []
cloudfront_origin_id           = "S3-rodrigo-frontend-bucket"

# Comportamento padrão
cloudfront_allowed_methods            = ["GET", "HEAD", "OPTIONS"]
cloudfront_cached_methods             = ["GET", "HEAD"]
cloudfront_cache_policy_id             = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"  # Managed-CachingOptimized
cloudfront_origin_request_policy_id   = null
cloudfront_response_headers_policy_id = null
cloudfront_viewer_protocol_policy     = "redirect-to-https"
cloudfront_function_arn                = null


cloudfront_ordered_behaviors = []
cloudfront_custom_error_responses = []
cloudfront_restriction_type     = "none"
cloudfront_restriction_locations = []

cloudfront_acm_certificate_arn      = ""
cloudfront_minimum_protocol_version = "TLSv1.2_2021"
cloudfront_ssl_support_method      = "sni-only"

