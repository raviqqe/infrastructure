resource "github_user_ssh_key" "mac" {
  title = "mac"
  key   = local.ssh.public_key
}
