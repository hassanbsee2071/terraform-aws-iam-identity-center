data "aws_ssoadmin_instances" "this" {}



data "aws_identitystore_group" "this" {
  for_each          = toset(local.groups_assignment)
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = each.value
    }
  }
depends_on = [aws_identitystore_group.this]  
}

data "aws_identitystore_user" "this" {
  for_each          = toset(local.users_assignment)
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = each.value
    }
  }
depends_on = [aws_identitystore_user.this]  
}














