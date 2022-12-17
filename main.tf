terraform {
  cloud {
    organization = "raviqqe"

    workspaces {
      name = "infrastructure"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

provider "google" {
  project = "dev-server-199623"
  region  = "us-west1"
  zone    = "us-west1b"
}
