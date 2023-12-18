resource "aws_iam_user" "one_rpc_ci" {
  name = "one_rpc_ci"
  path = "/system/"
}

resource "aws_iam_access_key" "lb" {
  user    = aws_iam_user.lb.name
  pgp_key = "keybase:some_person_that_exists"
}

data "aws_iam_policy_document" "lb_ro" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "lb_ro" {
  name   = "test"
  user   = aws_iam_user.lb.name
  policy = data.aws_iam_policy_document.lb_ro.json
}

output "secret" {
  value     = aws_iam_access_key.lb.encrypted_secret
  sensitive = true
}
