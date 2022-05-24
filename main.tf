terraform {
  cloud {
    organization = "raviqqe"

    workspaces {
      name = "infrastructure"
    }
  }
}

variable "record_ttl" {
  default = "300"
}

provider "aws" {
  region = "us-west-2"
}

provider "google" {
  project = "dev-server-199623"
  region  = "us-west1"
}
