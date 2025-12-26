###################################################################################################################
################################################## Frontend #######################################################
###################################################################################################################

#######################
#### S3 Bucket ####
#######################

module "s3_frontend" {
  source              = "./modulos/Armazenamento/prod/s3"
  bucket_name         = var.s3_bucket_name
  environment         = var.s3_environment
  enable_versioning   = var.s3_enable_versioning
  enable_encryption   = var.s3_enable_encryption
  bucket_policy_json  = var.s3_bucket_policy_json
  tags                = var.tags_s3
}

#######################
#### S3 Website Configuration ####
#######################

module "s3_website_config" {
  source      = "./modulos/Armazenamento/prod/s3-website-configuration"
  bucket_name = module.s3_frontend.bucket_name
}

#######################
#### CloudFront OAI ####
#######################

module "cloudfront_oai" {
  source  = "./modulos/Frontend/prod/cloudfront-oai"
  comment = var.cloudfront_oai_comment
}

#######################
#### S3 Bucket Policy for CloudFront OAI ####
#######################

resource "aws_s3_bucket_policy" "cloudfront_oai" {
  bucket = module.s3_frontend.bucket_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontOAI"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${module.cloudfront_oai.oai_id}"
        }
        Action   = "s3:GetObject"
        Resource = "${module.s3_frontend.bucket_arn}/*"
      }
    ]
  })
}

#######################
#### CloudFront Distribution ####
#######################

module "cloudfront_distribution" {
  source     = "./modulos/Frontend/prod/cloudfront-distribution"
  config_json = jsonencode({
    Enabled             = true
    Comment             = var.cloudfront_comment
    DefaultRootObject   = var.cloudfront_default_root_object
    PriceClass          = var.cloudfront_price_class
    Aliases             = var.cloudfront_aliases
    Origin = {
      DomainName              = module.s3_frontend.bucket_regional_domain_name
      OriginId                = var.cloudfront_origin_id
      OriginAccessIdentityPath = module.cloudfront_oai.oai_cloudfront_access_identity_path
    }
    DefaultBehavior = {
      AllowedMethods            = var.cloudfront_allowed_methods
      CachedMethods             = var.cloudfront_cached_methods
      CachePolicyId             = var.cloudfront_cache_policy_id
      OriginRequestPolicyId     = var.cloudfront_origin_request_policy_id
      ResponseHeadersPolicyId   = var.cloudfront_response_headers_policy_id
      ViewerProtocolPolicy      = var.cloudfront_viewer_protocol_policy
      FunctionArn               = var.cloudfront_function_arn != null ? var.cloudfront_function_arn : null
    }
    OrderedBehaviors = var.cloudfront_ordered_behaviors
    CustomErrorResponses = var.cloudfront_custom_error_responses
    Restrictions = {
      Type      = var.cloudfront_restriction_type
      Locations = var.cloudfront_restriction_locations
    }
    ViewerCertificate = var.cloudfront_acm_certificate_arn != "" ? {
      AcmCertificateArn      = var.cloudfront_acm_certificate_arn
      MinimumProtocolVersion = var.cloudfront_minimum_protocol_version
      SslSupportMethod       = var.cloudfront_ssl_support_method
    } : {
      AcmCertificateArn      = ""
      MinimumProtocolVersion = var.cloudfront_minimum_protocol_version
      SslSupportMethod       = var.cloudfront_ssl_support_method
    }
  })
}

