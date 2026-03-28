terraform {
  required_providers {
    aws = {
      source  = "aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_amplify_app" "main" {
  name = var.name
}

resource "aws_amplify_backend_environment" "production" {
  app_id           = aws_amplify_app.main.id
  environment_name = "production"
}
