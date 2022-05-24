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

resource "aws_route53_zone" "ein_com" {
  name = "ein-lang.com"
}

resource "aws_route53_zone" "ein_org" {
  name = "ein-lang.org"
}

resource "aws_route53_zone" "flame_com" {
  name = "flame-lang.com"
}

resource "aws_route53_zone" "flame_org" {
  name = "flame-lang.org"
}

resource "aws_route53_zone" "pen_com" {
  name = "pen-lang.com"
}

resource "aws_route53_zone" "pen_org" {
  name = "pen-lang.org"
}

resource "aws_route53_zone" "raviqqe_com" {
  name = "raviqqe.com"
}
