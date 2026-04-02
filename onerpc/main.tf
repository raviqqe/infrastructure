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

import {
  id = "oneRPC"
  to = module.repository.github_repository.repository
}

module "repository" {
  source = "../modules/github_repository"

  name         = "oneRPC"
  description  = "The router-less serverless RPC framework for TypeScript"
  homepage_url = "https://raviqqe.github.io/oneRPC"
  topics = [
    "aws-lambda",
    "edge-computing",
    "nextjs",
    "rpc",
    "typescript",
  ]
  private = false
}

module "terraform_oidc" {
  source = "../modules/terraform_oidc"

  organization = "raviqqe"
  project      = "onerpc"
  workspace    = "onerpc"
}

module "github_oidc" {
  source = "../modules/github_oidc"

  owner      = module.repository.owner
  repository = module.repository.name
}
