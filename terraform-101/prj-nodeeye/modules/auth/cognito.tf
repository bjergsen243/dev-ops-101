resource "aws_cognito_user_pool" "pool" {
  name = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-user-pool"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]
  lambda_config {
  }
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "org_id"
    required                 = false

    string_attribute_constraints {
      max_length = "512"
      min_length = "0"
    }
  }

  lifecycle {
    ignore_changes = ["lambda_config"]
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name                   = "${lower(lookup(var.common, "customer"))}-${upper(terraform.workspace)}-user-pool-client"
  access_token_validity  = 30
  id_token_validity      = 30
  refresh_token_validity = 1
  token_validity_units {
    id_token      = "minutes"
    access_token  = "minutes"
    refresh_token = "days"
  }
  explicit_auth_flows = [
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
  generate_secret               = false
  prevent_user_existence_errors = "ENABLED"

  user_pool_id = aws_cognito_user_pool.pool.id

  read_attributes = [
    "custom:org_id",
    "email",
    "email_verified",
    "name",
    "phone_number",
    "phone_number_verified",
    "zoneinfo",
  ]
  write_attributes = [
    "email",
    "name",
    "picture",
  ]

  callback_urls = [
    "http://localhost:3000",
    "http://localhost:4000",
  ]

  logout_urls = [
    "http://localhost:3000",
    "http://localhost:4000",
  ]

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["openid"]
  supported_identity_providers         = ["COGNITO"]
}



resource "aws_cognito_identity_pool" "main" {
  identity_pool_name               = "${lookup(var.common, "${terraform.workspace}.profile", var.common["default.profile"])}-id-pool"
  allow_unauthenticated_identities = true
  allow_classic_flow               = false

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.client.id
    provider_name           = "cognito-idp.${lookup(var.common, "${terraform.workspace}.region", var.common["default.region"])}.amazonaws.com/${aws_cognito_user_pool.pool.id}"
    server_side_token_check = false
  }
}
