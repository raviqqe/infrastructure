data "github_user" "me" {
  username = ""
}

resource "github_user_ssh_key" "mac" {
  title = "mac"
  key   = local.ssh.public_key
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["1b511abead59c6ce207077c0bf0e0043b1382612"]
}
