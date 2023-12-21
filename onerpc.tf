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

data "aws_iam_policy_document" "onerpc_ci" {
  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameter"]
    resources = ["arn:aws:ssm:us-west-2:${data.aws_caller_identity.current.id}:parameter/cdk-bootstrap/hnb659fds/*"]
  }
}

resource "aws_iam_policy" "onerpc_ci" {
  name   = "onerpc_ci"
  policy = data.aws_iam_policy_document.onerpc_ci.json
}

data "aws_iam_policy_document" "onerpc_ci_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${module.onerpc_repository.full_name}:ref:refs/heads/main"]
    }
  }
}

resource "aws_iam_role" "onerpc_ci" {
  name               = "onerpc_ci"
  assume_role_policy = data.aws_iam_policy_document.onerpc_ci_assume_role.json
}

resource "aws_iam_role_policy_attachment" "onerpc_ci" {
  role       = aws_iam_role.onerpc_ci.name
  policy_arn = aws_iam_policy.onerpc_ci.arn
}

resource "aws_iam_user" "onerpc_ci" {
  name = "onerpc_ci"
  path = "/system/"
}

resource "aws_iam_user_policy_attachment" "onerpc_ci" {
  user       = aws_iam_user.onerpc_ci.name
  policy_arn = aws_iam_policy.onerpc_ci.arn
}

resource "aws_iam_access_key" "onerpc_ci" {
  user    = aws_iam_user.onerpc_ci.name
  pgp_key = "keybase:${local.keybase_user}"
}

output "onerpc_ci_access_key_id" {
  value = aws_iam_access_key.onerpc_ci.id
}

output "onerpc_ci_secret_access_key" {
  value = aws_iam_access_key.onerpc_ci.encrypted_secret
}
