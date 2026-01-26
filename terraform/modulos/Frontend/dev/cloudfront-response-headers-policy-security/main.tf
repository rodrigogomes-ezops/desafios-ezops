resource "aws_cloudfront_response_headers_policy" "this" {
  name    = "SecurityHeadersPolicy"
  comment = "Security headers (HSTS, CSP, XSS, Frame, Permissions, COEP/COOP/CORP)"

  security_headers_config {
    content_security_policy {
      override                  = true
      content_security_policy    = var.content_security_policy_security_headers
    }

    strict_transport_security {
      override                   = true
      include_subdomains          = true
      preload                     = true
      access_control_max_age_sec  = 31536000
    }

    xss_protection {
      override    = true
      protection  = true
      mode_block  = true
    }

    frame_options {
      override     = true
      frame_option = "SAMEORIGIN"
    }

    content_type_options {
      override = true
    }

    referrer_policy {
      override         = true
      referrer_policy  = "strict-origin-when-cross-origin"
    }
  }

  custom_headers_config {
    items {
      header   = "Permissions-Policy"
      override = true
      value    = "accelerometer=(), autoplay=(), camera=(), cross-origin-isolated=*, display-capture=*, encrypted-media=(), fullscreen=*, geolocation=*, gyroscope=*, keyboard-map=*, magnetometer=(), microphone=(), midi=(), payment=*, picture-in-picture=*, publickey-credentials-get=*, screen-wake-lock=*, sync-xhr=*, usb=(), web-share=*, xr-spatial-tracking=*, clipboard-read=*, clipboard-write=*, gamepad=(), hid=(), idle-detection=*, serial=(), window-placement=*"
    }

    items {
      header   = "Cross-Origin-Embedder-Policy"
      override = true
      value    = "unsafe-none"
    }

    items {
      header   = "Cross-Origin-Opener-Policy"
      override = true
      value    = "cross-origin"
    }

    items {
      header   = "Cross-Origin-Resource-Policy"
      override = true
      value    = "same-origin"
    }
  }
}
