resource "aws_cognito_user_pool" "this" {
  name = var.name


  alias_attributes         = ["preferred_username"]
  auto_verified_attributes = ["email"]

  username_configuration {
    case_sensitive = true
  }

  schema {
    attribute_data_type = "String"
    mutable             = true
    name                = "email"
    required            = true
    string_attribute_constraints {
      min_length = 1
      max_length = 2048
    }
  }

  password_policy {
    minimum_length                   = "8"
    require_lowercase                = "1"
    require_numbers                  = "1"
    require_symbols                  = "1"
    require_uppercase                = "1"
    temporary_password_validity_days = "7"
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 1
    }

    recovery_mechanism {
      name     = "verified_email"
      priority = 2
    }
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

}
