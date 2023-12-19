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
  pgp_key = "keybase:515821172331"
}

output "secret" {
  value     = aws_iam_access_key.onerpc_ci.encrypted_secret
  sensitive = true
}
