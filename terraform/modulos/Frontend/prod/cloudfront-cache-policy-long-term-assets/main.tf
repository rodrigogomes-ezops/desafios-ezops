resource "aws_cloudfront_cache_policy" "this" {
    name = "LongTermAssetsPolicy" 
    comment = "Cache static assets for 1 year"
    default_ttl = 31536000
    min_ttl = 0
    max_ttl = 31536000
    
    parameters_in_cache_key_and_forwarded_to_origin {
        enable_accept_encoding_gzip = true
        cookies_config {
            cookie_behavior = "whitelist"
            cookies {
                items = ["PH_SESSION_ID", "NXSESSIONID", "_ga"]
            }
        }
        headers_config { header_behavior = "none" }
        query_strings_config { query_string_behavior = "none" }
    }
}

