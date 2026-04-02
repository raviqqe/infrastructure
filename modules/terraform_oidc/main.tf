terraform {
  required_providers {
    aws = {
      source  = "aws"
      version = "~> 5.81.0"
    }
  }
}

resource "aws_iam_openid_connect_provider" "terraform" {
  url             = "https://app.terraform.io"
  client_id_list  = ["aws.workload.identity"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
}
