terraform {
  required_version = "~> 1.17"

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
      version = "~> 6.13"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "github" {}

module "repository" {
  source = "../modules/github_repository"

  name    = "mafty"
  topics  = []
  private = true
}

import {
  to = github_repository_pages.repository
  id = "mafty"
}

resource "github_repository_pages" "repository" {
  repository = module.repository.name
  build_type = "workflow"
}

module "terraform_oidc" {
  source = "../modules/terraform_oidc"

  organization = "raviqqe"
  project      = "hathaway"
  workspace    = "hathaway"
}

module "github_oidc" {
  source = "../modules/github_oidc"

  owner         = module.repository.owner
  repository    = module.repository.name
  repository_id = module.repository.repo_id
}
