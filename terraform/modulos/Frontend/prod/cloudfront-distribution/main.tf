locals {
  cfg = jsondecode(var.config_json)

  # Suporta tanto Origin (objeto único) quanto Origins (array) para compatibilidade
  origins = try(local.cfg.Origins, try(local.cfg.Origin, null) != null ? [local.cfg.Origin] : [])
  defb   = try(local.cfg.DefaultBehavior, {})
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = try(local.cfg.Enabled, true)
  aliases             = try(local.cfg.Aliases, [])
  comment             = try(local.cfg.Comment, null)
  default_root_object = try(local.cfg.DefaultRootObject, "index.html")
  price_class         = try(local.cfg.PriceClass, "PriceClass_All")

  # Múltiplas origens
  dynamic "origin" {
    for_each = local.origins
    content {
      domain_name = origin.value.DomainName
      origin_id   = origin.value.OriginId

      # Configuração S3 (se OriginAccessIdentityPath estiver presente)
      dynamic "s3_origin_config" {
        for_each = try(origin.value.OriginAccessIdentityPath, null) != null ? [1] : []
        content {
          origin_access_identity = origin.value.OriginAccessIdentityPath
        }
      }

      # Configuração custom (ALB) - se não tiver OriginAccessIdentityPath
      dynamic "custom_origin_config" {
        for_each = try(origin.value.OriginAccessIdentityPath, null) == null ? [1] : []
        content {
          http_port                = try(origin.value.HttpPort, 80)
          https_port               = try(origin.value.HttpsPort, 443)
          origin_protocol_policy   = try(origin.value.OriginProtocolPolicy, "http-only")
          origin_ssl_protocols     = try(origin.value.OriginSslProtocols, ["TLSv1.2"])
          origin_read_timeout      = try(origin.value.OriginReadTimeout, 60)
          origin_keepalive_timeout = try(origin.value.OriginKeepaliveTimeout, 5)
        }
      }
    }
  }

  # Default behavior
  default_cache_behavior {
    target_origin_id           = try(local.defb.TargetOriginId, local.origins[0].OriginId)
    allowed_methods            = try(local.defb.AllowedMethods, ["GET","HEAD","OPTIONS"])
    cached_methods             = try(local.defb.CachedMethods,  ["GET","HEAD"])
    cache_policy_id            = local.defb.CachePolicyId
    origin_request_policy_id   = local.defb.OriginRequestPolicyId
    response_headers_policy_id = local.defb.ResponseHeadersPolicyId
    viewer_protocol_policy     = try(local.defb.ViewerProtocolPolicy, "redirect-to-https")

    dynamic "function_association" {
      for_each = try(local.defb.FunctionArn, null) != null ? [1] : []
      content {
        event_type   = "viewer-request"
        function_arn = local.defb.FunctionArn
      }
    }
  }

  # Ordered behaviors
  dynamic "ordered_cache_behavior" {
    for_each = try(local.cfg.OrderedBehaviors, [])
    content {
      path_pattern               = ordered_cache_behavior.value.PathPattern
      target_origin_id           = try(ordered_cache_behavior.value.TargetOriginId, local.origins[0].OriginId)
      allowed_methods            = try(ordered_cache_behavior.value.AllowedMethods, ["GET","HEAD","OPTIONS"])
      cached_methods             = try(ordered_cache_behavior.value.CachedMethods,  ["GET","HEAD"])
      cache_policy_id            = ordered_cache_behavior.value.CachePolicyId
      origin_request_policy_id   = ordered_cache_behavior.value.OriginRequestPolicyId
      response_headers_policy_id = ordered_cache_behavior.value.ResponseHeadersPolicyId
      viewer_protocol_policy     = try(ordered_cache_behavior.value.ViewerProtocolPolicy, "redirect-to-https")

      dynamic "function_association" {
        for_each = try(ordered_cache_behavior.value.FunctionArn, null) != null ? [1] : []
        content {
          event_type   = "viewer-request"
          function_arn = ordered_cache_behavior.value.FunctionArn
        }
      }
    }
  }

  # Custom errors
  dynamic "custom_error_response" {
    for_each = try(local.cfg.CustomErrorResponses, [])
    content {
      error_code            = custom_error_response.value.ErrorCode
      response_page_path    = custom_error_response.value.ResponsePagePath
      response_code         = custom_error_response.value.ResponseCode
      error_caching_min_ttl = try(custom_error_response.value.ErrorCachingMinTtl, 0)
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = try(local.cfg.Restrictions.Type, "none")
      locations        = try(local.cfg.Restrictions.Locations, [])
    }
  }

  viewer_certificate {
    acm_certificate_arn            = try(local.cfg.ViewerCertificate.AcmCertificateArn, null)
    cloudfront_default_certificate = try(local.cfg.ViewerCertificate.AcmCertificateArn, null) == null || try(local.cfg.ViewerCertificate.AcmCertificateArn, null) == "" ? true : false
    minimum_protocol_version       = try(local.cfg.ViewerCertificate.MinimumProtocolVersion, "TLSv1.2_2021")
    ssl_support_method             = try(local.cfg.ViewerCertificate.SslSupportMethod, "sni-only")
  }
}
