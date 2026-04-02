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

module "terraform_oidc" {
  source = "../modules/terraform_oidc"

  organization = "raviqqe"
  project      = "onerpc"
  workspace    = "onerpc"
}

module "github_oidc" {
  source = "../modules/github_oidc"

  owner      = "raviqqe"
  repository = "oneRPC"
}
