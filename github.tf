resource "github_user_ssh_key" "mac" {
  title = "mac"
  key   = local.ssh.public_key
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "266362248691-342342xasdasdasda-apps.googleusercontent.com",
  ]
  thumbprint_list = ["cf23df2207d99a74fbe169e3eba035e633b65d94"]
}
