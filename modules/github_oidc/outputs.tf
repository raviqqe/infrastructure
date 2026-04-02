output "role_arn" {
  value = aws_iam_role.cdk.arn
}

output "role_name" {
  value = aws_iam_role.cdk.name
}
