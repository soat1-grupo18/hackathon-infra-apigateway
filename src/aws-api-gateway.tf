resource "aws_api_gateway_vpc_link" "this" {
  name        = "ecs-vpclink"
  description = "ECS VPC Link"
  target_arns = [data.aws_lb.lb_vpclink.arn]
}

resource "aws_api_gateway_rest_api" "this" {
  body = templatefile("${path.module}/templates/apigw-openapi.json", {
    vpclink_id           = aws_api_gateway_vpc_link.this.id
    cognito_userpool_arn = aws_cognito_user_pool.this.arn
  })

  name        = "fiap-rest-api"
  description = "FIAP REST API for FIAP ECS Cluster"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(aws_api_gateway_rest_api.this.body)
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "latest" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = "latest"

  # Docs = https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway.arn
    format          = "{ \"requestId\": \"$context.requestId\", \"extendedRequestId\": \"$context.extendedRequestId\", \"ip\": \"$context.identity.sourceIp\", \"caller\": \"$context.identity.caller\", \"user\": \"$context.identity.user\", \"requestTime\": \"$context.requestTime\", \"httpMethod\": \"$context.httpMethod\", \"resourcePath\": \"$context.resourcePath\", \"status\": \"$context.status\", \"protocol\": \"$context.protocol\", \"responseLength\": \"$context.responseLength\" }"
  }
}
