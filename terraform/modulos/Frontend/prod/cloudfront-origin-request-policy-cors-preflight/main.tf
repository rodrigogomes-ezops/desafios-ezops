resource "aws_cloudfront_origin_request_policy" "this" {
    name = "CorsPreflightPolicy" 
    comment = "Forward Origin header for S3 CORS"
    cookies_config {
        cookie_behavior = "whitelist"
        cookies {
            items = ["PH_SESSION_ID", "NXSESSIONID", "_ga"]
        }
    }
    headers_config {
        header_behavior = "whitelist"
        headers { items = ["Origin"] }
    }
    query_strings_config { query_string_behavior = "none" }
}
