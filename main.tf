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
      version = "~>5.81.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }

    google = {
      source  = "google"
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
