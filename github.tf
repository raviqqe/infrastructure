data "github_user" "current" {
  username = ""
}

resource "github_user_ssh_key" "mac" {
  title = "mac"
  key   = local.ssh.public_key
}
