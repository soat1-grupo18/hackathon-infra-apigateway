module "lambda_authenticator" {
  source  = "terraform-aws-modules/lambda/aws"
  version = ">= 6.0.0, < 7.0.0"

  function_name = "fiap-authenticator"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  publish       = true

  timeout     = 15
  memory_size = 128

  source_path = "${path.module}/lambdas/authenticate/index.mjs"

  environment_variables = {
    "TOKEN_SECRET" = "MY_S3CR3T"
  }

  allowed_triggers = {
    APIGateway = {
      service    = "apigateway"
      source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*"
    }
  }
}

module "lambda_authorizer" {
  source  = "terraform-aws-modules/lambda/aws"
  version = ">= 6.0.0, < 7.0.0"

  function_name = "fiap-authorizer"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  publish       = true

  #   attach_policy_json = true
  #   policy_json        = data.aws_iam_policy_document.lambda_twitch_additional_policy.json

  timeout     = 15
  memory_size = 128

  source_path = "${path.module}/lambdas/authorize/index.mjs"

  environment_variables = {
    "TOKEN_SECRET" = "MY_S3CR3T"
  }

  allowed_triggers = {
    APIGateway = {
      service    = "apigateway"
      source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*"
    }
  }
}
