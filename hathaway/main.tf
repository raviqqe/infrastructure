terraform {
  cloud {
    organization = "raviqqe"

    workspaces {
      name = "hathaway"
    }
  }

  required_providers {
    aws = {
      source  = "aws"
      version = "~> 6.58"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6.11"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

provider "github" {}

module "repository" {
  source = "../modules/github_repository"

  name    = "hathaway"
  topics  = []
  private = true
}

module "terraform_oidc" {
  source = "../modules/terraform_oidc"

  organization = "raviqqe"
  project      = "hathaway"
  workspace    = "hathaway"
}

module "github_oidc" {
  source = "../modules/github_oidc"

  owner      = module.repository.owner
  repository = module.repository.name
}
