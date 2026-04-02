terraform {
  cloud {
    organization = "raviqqe"

    workspaces {
      name = "onerpc"
    }
  }

  required_providers {
    aws = {
      source  = "aws"
      version = "~> 5.81.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6.11.1"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

provider "github" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

module "terraform_oidc" {
  source = "../modules/terraform_oidc"

  organization = "raviqqe"
  workspace    = "onerpc"
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["1b511abead59c6ce207077c0bf0e0043b1382612"]
}

resource "github_actions_environment_secret" "aws_account_id" {
  repository      = "oneRPC"
  environment     = "release"
  secret_name     = "aws_account_id"
  plaintext_value = data.aws_caller_identity.current.account_id
}

resource "github_actions_environment_secret" "aws_cdk_role" {
  repository      = "oneRPC"
  environment     = "release"
  secret_name     = "aws_role"
  plaintext_value = aws_iam_role.cdk.arn
}

data "aws_iam_policy_document" "cdk" {
  statement {
    actions = ["sts:AssumeRole"]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/cdk-hnb659fds-deploy-role-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/cdk-hnb659fds-file-publishing-role-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/cdk-hnb659fds-image-publishing-role-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/cdk-hnb659fds-lookup-role-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}",
    ]
  }
}

resource "aws_iam_policy" "cdk" {
  name   = "cdk"
  policy = data.aws_iam_policy_document.cdk.json
}

data "aws_iam_policy_document" "cdk_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:raviqqe/oneRPC:environment:release"]
    }
  }
}

resource "aws_iam_role" "cdk" {
  name               = "cdk"
  assume_role_policy = data.aws_iam_policy_document.cdk_assume_role.json
}

resource "aws_iam_role_policy_attachment" "cdk" {
  role       = aws_iam_role.cdk.name
  policy_arn = aws_iam_policy.cdk.arn
}
