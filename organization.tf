resource "aws_organizations_organization" "organization" {
  feature_set                   = "ALL"
  aws_service_access_principals = ["account.amazonaws.com", "sso.amazonaws.com"]
}

resource "aws_organizations_account" "hathaway" {
  name  = "hathaway"
  email = "raviqqe+hathaway@gmail.com"

  parent_id = aws_organizations_organization.organization.roots[0].id
}

resource "aws_organizations_account" "onerpc" {
  name  = "onerpc"
  email = "raviqqe+onerpc@gmail.com"

  parent_id = aws_organizations_organization.organization.roots[0].id
}

data "aws_ssoadmin_instances" "identity_center" {}

resource "aws_identitystore_user" "admin" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.identity_center.identity_store_ids)[0]

  display_name = "Yota Toyama"
  user_name    = "raviqqe"

  name {
    given_name  = "Yota"
    family_name = "Toyama"
  }

  emails {
    value   = "raviqqe@gmail.com"
    primary = true
  }
}

resource "aws_ssoadmin_permission_set" "admin" {
  instance_arn = tolist(data.aws_ssoadmin_instances.identity_center.arns)[0]
  name         = "AdministratorAccess"
}

resource "aws_ssoadmin_managed_policy_attachment" "admin" {
  instance_arn       = aws_ssoadmin_permission_set.admin.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_ssoadmin_account_assignment" "admin" {
  for_each = {
    management = data.aws_caller_identity.current.account_id
    hathaway   = aws_organizations_account.hathaway.id
    onerpc     = aws_organizations_account.onerpc.id
  }

  instance_arn       = aws_ssoadmin_permission_set.admin.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
  principal_id       = aws_identitystore_user.admin.user_id
  principal_type     = "USER"
  target_id          = each.value
  target_type        = "AWS_ACCOUNT"
}
