data "aws_iam_policy_document" "onerpc_ci" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_user" "onerpc_ci" {
  name = "onerpc_ci"
  path = "/system/"
}

resource "aws_iam_role" "test_role" {
  name = "onerpc_ci"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
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
