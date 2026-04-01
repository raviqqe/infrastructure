import {
  id = "hathaway"
  to = module.hathaway_repository.github_repository.repository
}

module "hathaway_repository" {
  source = "./modules/github_repository"

  name    = "hathaway"
  topics  = []
  private = true
}

resource "github_actions_environment_secret" "hathaway_aws_account_id" {
  repository      = module.hathaway_repository.name
  environment     = "release"
  secret_name     = "aws_account_id"
  plaintext_value = aws_organizations_account.hathaway.id
}

resource "github_actions_environment_secret" "hathaway_aws_cdk_role" {
  repository      = module.hathaway_repository.name
  environment     = "release"
  secret_name     = "aws_role"
  plaintext_value = aws_iam_role.hathaway_cdk.arn
}

data "aws_iam_policy_document" "hathaway_cdk" {
  statement {
    actions = ["sts:AssumeRole"]
    resources = [
      "arn:aws:iam::${aws_organizations_account.hathaway.id}:role/cdk-hnb659fds-deploy-role-${aws_organizations_account.hathaway.id}-${data.aws_region.current.name}",
      "arn:aws:iam::${aws_organizations_account.hathaway.id}:role/cdk-hnb659fds-file-publishing-role-${aws_organizations_account.hathaway.id}-${data.aws_region.current.name}",
      "arn:aws:iam::${aws_organizations_account.hathaway.id}:role/cdk-hnb659fds-image-publishing-role-${aws_organizations_account.hathaway.id}-${data.aws_region.current.name}",
      "arn:aws:iam::${aws_organizations_account.hathaway.id}:role/cdk-hnb659fds-lookup-role-${aws_organizations_account.hathaway.id}-${data.aws_region.current.name}",
    ]
  }
}

resource "aws_iam_policy" "hathaway_cdk" {
  name   = "hathaway_cdk"
  policy = data.aws_iam_policy_document.hathaway_cdk.json
}

data "aws_iam_policy_document" "hathaway_cdk_assume_role" {
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
      values   = ["repo:${module.hathaway_repository.full_name}:environment:release"]
    }
  }
}

resource "aws_iam_role" "hathaway_cdk" {
  name               = "hathaway-cdk"
  assume_role_policy = data.aws_iam_policy_document.hathaway_cdk_assume_role.json
}

resource "aws_iam_role_policy_attachment" "hathaway_cdk" {
  role       = aws_iam_role.hathaway_cdk.name
  policy_arn = aws_iam_policy.hathaway_cdk.arn
}
