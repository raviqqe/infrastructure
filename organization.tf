resource "aws_organizations_organization" "organization" {
  feature_set = "ALL"
}

resource "aws_organizations_account" "onerpc" {
  name  = "onerpc"
  email = "raviqqe+onerpc@gmail.com"

  parent_id = aws_organizations_organization.organization.roots[0].id
}

resource "aws_organizations_account" "hathaway" {
  name  = "hathaway"
  email = "raviqqe+hathaway@gmail.com"

  parent_id = aws_organizations_organization.organization.roots[0].id
}
