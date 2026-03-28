terraform {
  cloud {
    organization = "raviqqe"

    workspaces {
      name = "infrastructure"
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

    google = {
      source  = "google"
      version = "~> 6.3.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "google" {
  project = "dev-server-199623"
  region  = "us-west1"
  zone    = "us-west1-b"
}

provider "github" {}
