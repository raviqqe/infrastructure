resource "aws_iam_user" "one_rpc_ci" {
  name = "one_rpc_ci"
  path = "/system/"
}

resource "aws_iam_access_key" "one_rpc_ci" {
  user    = aws_iam_user.one_rpc_ci.name
  pgp_key = "keybase:some_person_that_exists"
}

data "aws_iam_policy_document" "one_rpc_ci" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "one_rpc_ci" {
  name   = "test"
  user   = aws_iam_user.one_rpc_ci.name
  policy = data.aws_iam_policy_document.one_rpc_ci.json
}

output "secret" {
  value     = aws_iam_access_key.one_rpc_ci.encrypted_secret
  sensitive = true
}
