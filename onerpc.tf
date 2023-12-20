module "onerpc_repository" {
  source = "git::https://github.com/raviqqe/terraform-modules//github_repository"

  name        = "oneRPC"
  description = "The router-less serverless RPC framework for TypeScript"
  topics = [
    "aws-lambda",
    "edge-computing",
    "nextjs",
    "rpc",
    "typescript",
  ]
  private = false
}

resource "github_actions_secret" "aws_role" {
  repository      = module.onerpc_repository.name
  secret_name     = "aws_role"
  plaintext_value = aws_iam_role.onerpc_ci.arn
}

data "aws_iam_policy_document" "onerpc_ci_assume_role" {
  statement {
    actions = ["sts:AssumeRole", "sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
  }
}

resource "aws_iam_role" "onerpc_ci" {
  name               = "onerpc_ci"
  assume_role_policy = data.aws_iam_policy_document.onerpc_ci_assume_role.json
}

resource "aws_iam_user" "onerpc_ci" {
  name = "onerpc_ci"
  path = "/system/"
}

data "aws_iam_policy_document" "onerpc_ci" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "onerpc_ci" {
  name   = "onerpc_ci"
  user   = aws_iam_user.onerpc_ci.name
  policy = data.aws_iam_policy_document.onerpc_ci.json
}

resource "aws_iam_access_key" "onerpc_ci" {
  user    = aws_iam_user.onerpc_ci.name
  pgp_key = "keybase:raviqqe"
}

output "onerpc_ci_access_key_id" {
  value = aws_iam_access_key.onerpc_ci.id
}

output "onerpc_ci_secret_access_key" {
  value = aws_iam_access_key.onerpc_ci.encrypted_secret
}
