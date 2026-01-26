locals {
  cfg = jsondecode(var.config_json)

  # Se houver 'Origins', usa; senão tenta um único 'Origin'; senão lista vazia
  origins = try(local.cfg.Origins, try([local.cfg.Origin], []))

  # DefaultBehavior (atalho)
  defb = try(local.cfg.DefaultBehavior, {})
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = try(local.cfg.Enabled, true)
  aliases             = try(local.cfg.Aliases, [])
  comment             = try(local.cfg.Comment, null)
  default_root_object = try(local.cfg.DefaultRootObject, "index.html")
  price_class         = try(local.cfg.PriceClass, "PriceClass_All")
  is_ipv6_enabled     = try(local.cfg.IsIpv6Enabled, null)

  # --- ORIGINS (múltiplos S3) ---
  dynamic "origin" {
    for_each = local.origins
    content {
      domain_name = origin.value.DomainName
      origin_id   = origin.value.OriginId

      s3_origin_config {
        origin_access_identity = try(origin.value.OriginAccessIdentityPath, null)
      }

      origin_path = try(origin.value.OriginPath, null)

      dynamic "custom_header" {
        for_each = try(origin.value.CustomHeaders, [])
        content {
          name  = custom_header.value.Name
          value = custom_header.value.Value
        }
      }
    }
  }

  # --- DEFAULT BEHAVIOR ---
  default_cache_behavior {
    # Usa o TargetOriginId do JSON; se não vier, cai no primeiro origin da lista
    target_origin_id           = try(local.defb.TargetOriginId, local.origins[0].OriginId)
    allowed_methods            = try(local.defb.AllowedMethods, ["GET","HEAD","OPTIONS"])
    cached_methods             = try(local.defb.CachedMethods,  ["GET","HEAD"])
    cache_policy_id            = try(local.defb.CachePolicyId, null)
    origin_request_policy_id   = try(local.defb.OriginRequestPolicyId, null)
    response_headers_policy_id = try(local.defb.ResponseHeadersPolicyId, null)
    viewer_protocol_policy     = try(local.defb.ViewerProtocolPolicy, "redirect-to-https")
    trusted_key_groups         = try(local.defb.TrustedKeyGroups, null)
    compress                   = try(local.defb.Compress, null)

    dynamic "function_association" {
      for_each = try(local.defb.FunctionArn, "") != "" ? [1] : []
      content {
        event_type   = "viewer-request"
        function_arn = local.defb.FunctionArn
      }
    }
  }

  # --- ORDERED BEHAVIORS ---
  dynamic "ordered_cache_behavior" {
    for_each = try(local.cfg.OrderedBehaviors, [])
    content {
      path_pattern               = ordered_cache_behavior.value.PathPattern
      target_origin_id           = try(ordered_cache_behavior.value.TargetOriginId, local.origins[0].OriginId)
      allowed_methods            = try(ordered_cache_behavior.value.AllowedMethods, ["GET","HEAD","OPTIONS"])
      cached_methods             = try(ordered_cache_behavior.value.CachedMethods,  ["GET","HEAD"])
      cache_policy_id            = try(ordered_cache_behavior.value.CachePolicyId, null)
      origin_request_policy_id   = try(ordered_cache_behavior.value.OriginRequestPolicyId, null)
      response_headers_policy_id = try(ordered_cache_behavior.value.ResponseHeadersPolicyId, null)
      viewer_protocol_policy     = try(ordered_cache_behavior.value.ViewerProtocolPolicy, "redirect-to-https")
      trusted_key_groups         = try(ordered_cache_behavior.value.TrustedKeyGroups, null)
      compress                   = try(ordered_cache_behavior.value.Compress, null)

      dynamic "function_association" {
        for_each = try(ordered_cache_behavior.value.FunctionArn, "") != "" ? [1] : []
        content {
          event_type   = "viewer-request"
          function_arn = ordered_cache_behavior.value.FunctionArn
        }
      }
    }
  }

  # --- CUSTOM ERRORS ---
  dynamic "custom_error_response" {
    for_each = try(local.cfg.CustomErrorResponses, [])
    content {
      error_code            = custom_error_response.value.ErrorCode
      response_page_path    = custom_error_response.value.ResponsePagePath
      response_code         = custom_error_response.value.ResponseCode
      error_caching_min_ttl = try(custom_error_response.value.ErrorCachingMinTtl, 0)
    }
  }

  # --- RESTRICTIONS ---
  restrictions {
    geo_restriction {
      restriction_type = try(local.cfg.Restrictions.Type, "none")
      locations        = try(local.cfg.Restrictions.Locations, [])
    }
  }

  # --- CERT ---
  viewer_certificate {
    acm_certificate_arn            = local.cfg.ViewerCertificate.AcmCertificateArn
    cloudfront_default_certificate = false
    minimum_protocol_version       = try(local.cfg.ViewerCertificate.MinimumProtocolVersion, "TLSv1.2_2021")
    ssl_support_method             = try(local.cfg.ViewerCertificate.SslSupportMethod, "sni-only")
  }
}
