module "onerpc_repository" {
  source = "./modules/github_repository"

  name         = "oneRPC"
  description  = "The router-less serverless RPC framework for TypeScript"
  homepage_url = "https://raviqqe.github.io/oneRPC"
  topics = [
    "aws-lambda",
    "edge-computing",
    "nextjs",
    "rpc",
    "typescript",
  ]
  private = false
}

resource "github_actions_secret" "onerpc_aws_role" {
  repository      = module.onerpc_repository.name
  secret_name     = "aws_role"
  plaintext_value = aws_iam_role.onerpc_ci.arn
}

data "aws_iam_policy_document" "onerpc_ci" {
  statement {
    actions = ["sts:AssumeRole"]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/cdk-hnb659fds-deploy-role-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/cdk-hnb659fds-file-publishing-role-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/cdk-hnb659fds-image-publishing-role-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/cdk-hnb659fds-lookup-role-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}",
    ]
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
      values   = ["repo:${module.onerpc_repository.full_name}:environment:release"]
    }
  }
}

resource "aws_iam_role" "onerpc_ci" {
  name               = "onerpc-ci"
  assume_role_policy = data.aws_iam_policy_document.onerpc_ci_assume_role.json
}

resource "aws_iam_role_policy_attachment" "onerpc_ci" {
  role       = aws_iam_role.onerpc_ci.name
  policy_arn = aws_iam_policy.onerpc_ci.arn
}
