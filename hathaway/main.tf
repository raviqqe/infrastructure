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

import {
  id = "hathaway"
  to = module.repository.github_repository.repository
}

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

  owner      = "raviqqe"
  repository = module.repository.name
}
