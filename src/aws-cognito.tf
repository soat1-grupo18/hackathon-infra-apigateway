resource "aws_cognito_user_pool" "this" {
  name = "fiap-hackathon-pool"
}

resource "aws_cognito_user_pool_client" "fiap_hackathon_api" {
  name         = "fiap-hackathon-api"
  user_pool_id = aws_cognito_user_pool.this.id
  explicit_auth_flows = [
    "USER_PASSWORD_AUTH"
  ]
}

resource "aws_cognito_user" "olegon" {
  user_pool_id = aws_cognito_user_pool.this.id
  username     = "olegon"
}
