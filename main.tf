terraform {
  cloud {
    organization = "raviqqe"

    workspaces {
      name = "infrastructure"
    }
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

provider "google" {
  project = "dev-server-199623"
  region  = "us-west1"
  zone    = "us-west1-b"
}

provider "github" {}
