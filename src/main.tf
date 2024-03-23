terraform {
  backend "s3" {
    bucket         = "289389227463-terraform-backend"
    key            = "github/soat1-grupo18/hackathon-infra-apigateway"
    dynamodb_table = "289389227463-terraform-backend"
    region         = "sa-east-1"
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      terraform = "true"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
