resource "aws_cognito_user_pool" "this" {
  name = "fiap-hackathon-pool"
}

resource "aws_cognito_user" "olegon" {
  user_pool_id = aws_cognito_user_pool.this.id
  username     = "olegon"
}