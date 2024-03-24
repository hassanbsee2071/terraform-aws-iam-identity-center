resource "aws_identitystore_user" "this" {
  for_each = var.sso_users
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  user_name         = each.key 
  display_name      = each.value.display_name
  locale             = lookup(each.value, "locale", null)
  nickname           = lookup(each.value, "nickname", null)
  preferred_language = lookup(each.value, "preferred_language", null)
  profile_url        = lookup(each.value, "profile_url", null)
  timezone           = lookup(each.value, "timezone", null)
  title              = lookup(each.value, "title", null)
  user_type          = lookup(each.value, "user_type", null)

  name {
    given_name       = each.value.given_name
    family_name      = each.value.family_name
    formatted        = lookup(each.value, "formatted", null)
    honorific_prefix = lookup(each.value, "honorific_prefix", null)
    honorific_suffix = lookup(each.value, "honorific_suffix", null)
    middle_name      = lookup(each.value, "middle_name", null)
  }

  dynamic "emails" {
    for_each = each.value.emails


    content {
      value   = lookup(emails.value, "value", null)
      primary = lookup(emails.value, "primary", null)
      type    = lookup(emails.value, "type", null)
    }
  }

  dynamic "addresses" {
    for_each = each.value.addresses
    content {
      country        = lookup(addresses.value, "country", null)
      formatted      = lookup(addresses.value, "formatted", null)
      locality       = lookup(addresses.value, "locality", null)
      postal_code    = lookup(addresses.value, "postal_code", null)
      primary        = lookup(addresses.value, "primary", null)
      region         = lookup(addresses.value, "region", null)
      street_address = lookup(addresses.value, "street_address", null)
      type           = lookup(addresses.value, "type", null)
    }
  }

  dynamic "phone_numbers" {
    for_each = each.value.phone_numbers
    content {
      value   = lookup(phone_numbers.value, "value", null)
      primary = lookup(phone_numbers.value, "primary", null)
      type    = lookup(phone_numbers.value, "type", null)
    }
  }
}

resource "aws_identitystore_group" "this" {
  for_each = var.sso_groups_okta

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  display_name      = each.key
  description       = lookup(each.value, "description", null)
}


resource "aws_identitystore_group_membership" "this" {
  for_each = local.assignment_of_user_to_groups
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  group_id          = aws_identitystore_group.this[each.value.sso_group].group_id
  member_id         = aws_identitystore_user.this[each.value.sso_name].user_id
}



resource "aws_ssoadmin_permission_set" "this" {
  for_each = var.permission_sets

  name             = each.key
  description      = lookup(each.value, "description", null)
  instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  relay_state      = lookup(each.value, "relay_state", null)
  session_duration = lookup(each.value, "session_duration", null)
  tags             = lookup(each.value, "tags", {})
    lifecycle {
    ignore_changes = [
      id,
      instance_arn,
    ]
  }
}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each = local.permission_set_managed_policy_map

  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  managed_policy_arn = each.value.policy_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.ps_name].arn
}


resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  for_each = local.inline_policy_if_present
  inline_policy      = each.value.inline_policy
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.this[each.key].arn
}




resource "aws_ssoadmin_customer_managed_policy_attachment" "this" {
  for_each = local.customer_managed_policy_map

  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.permission_set_name].arn
  customer_managed_policy_reference {
    name = each.value.policy_name
    path = "/"
  }
}




resource "aws_ssoadmin_account_assignment" "this" {
  for_each = local.account_aasigment_map

  instance_arn       = each.value.permission_set.instance_arn
  permission_set_arn = each.value.permission_set.arn
  principal_id       = each.value.principal_type == "GROUP" ? data.aws_identitystore_group.this[each.value.principal_name].id : data.aws_identitystore_user.this[each.value.principal_name].id
  principal_type     = each.value.principal_type

  target_id   = each.value.account_id
  target_type = "AWS_ACCOUNT"
    lifecycle {
    ignore_changes = [
      principal_id,
      id,
      instance_arn,
      permission_set_arn
    ]
  }

}






