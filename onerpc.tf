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

resource "github_actions_environment_secret" "onerpc_aws_cdk_role" {
  repository      = module.onerpc_repository.name
  environment     = "release"
  secret_name     = "aws_role"
  plaintext_value = aws_iam_role.onerpc_cdk.arn
}

data "aws_iam_policy_document" "onerpc_cdk" {
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

resource "aws_iam_policy" "onerpc_cdk" {
  name   = "onerpc_cdk"
  policy = data.aws_iam_policy_document.onerpc_cdk.json
}

data "aws_iam_policy_document" "onerpc_cdk_assume_role" {
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

resource "aws_iam_role" "onerpc_cdk" {
  name               = "onerpc-cdk"
  assume_role_policy = data.aws_iam_policy_document.onerpc_cdk_assume_role.json
}

resource "aws_iam_role_policy_attachment" "onerpc_cdk" {
  role       = aws_iam_role.onerpc_cdk.name
  policy_arn = aws_iam_policy.onerpc_cdk.arn
}
