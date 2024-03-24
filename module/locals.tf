
locals {

//// This is for grouping users with groups ////////

map_of_users_containing_sso_group   = { for sso_name, attributes in var.sso_users : sso_name => attributes if can(attributes.sso_groups) }
mapping_of_sso_users_with_groups = flatten([
    for sso_user_name, attributes in local.map_of_users_containing_sso_group : [
      for group in attributes.sso_groups : {
        sso_name     = sso_user_name
        sso_group    = group
      } if can(attributes.sso_groups)
    ]
  ])
assignment_of_user_to_groups          = { for attributes in local.mapping_of_sso_users_with_groups : "${attributes.sso_name}.${attributes.sso_group}" => attributes }
  
users_list  = [for assignment in local.mapping_of_sso_users_with_groups : assignment.sso_name]
groups_list = [for assignment in local.mapping_of_sso_users_with_groups : assignment.sso_group]

unique_users_list = distinct(local.users_list)
unique_groups_list = distinct(local.groups_list)
//// This is for looping over permission_set to get inline policy if present ////////
inline_policy_if_present = { for permission_set_name, permission_set_attribute in var.permission_sets : permission_set_name => permission_set_attribute if can(permission_set_attribute.inline_policy) }


//// This is for attaching customer managed policies to permission sets...  ///////

  customer_managed_ps   = { for permission_set_name, permission_set_attribute in var.permission_sets : permission_set_name => permission_set_attribute if can(permission_set_attribute.customer_managed_policies) }
 
  customer_ps_policy_maps = flatten([
    for permission_set_name, permission_set_attribute in local.customer_managed_ps : [
      for policy in permission_set_attribute.customer_managed_policies : {
        permission_set_name     = permission_set_name
        policy_name = policy
      } if can(permission_set_attribute.customer_managed_policies)
    ]
  ])

 customer_managed_policy_map          = { for attribute in local.customer_ps_policy_maps : "${attribute.permission_set_name}.${attribute.policy_name}" => attribute }
  



//// This is for attaching accounts...  ///////

  account_assignments = flatten([
    for assignment in var.account_assignments : [
      for account_id in assignment.account_ids : {
        principal_name = assignment.principal_name
        principal_type = assignment.principal_type
        permission_set = aws_ssoadmin_permission_set.this[assignment.permission_set]
        account_id     = account_id

      }
    ]
  ])


account_aasigment_map={ for assignment in local.account_assignments : "${assignment.principal_name}.${assignment.permission_set.name}.${assignment.account_id}" => assignment }
users_assignment  = distinct([for assignment in var.account_assignments : assignment.principal_name  if assignment.principal_type == "USER"])
groups_assignment = distinct([for index, assignment in var.account_assignments : var.account_assignments[index].principal_name if assignment.principal_type == "GROUP"])



////This is for adding aws managed policies ////
managed_ps   = { for ps_name, ps_attrs in var.permission_sets : ps_name => ps_attrs if can(ps_attrs.managed_policies) }
  permission_set_managed_policy = flatten([
    for permission_set, attributes in local.managed_ps : [
      for policy in attributes.managed_policies : {
        ps_name    = permission_set
        policy_arn = policy
      } if can(attributes.managed_policies)
    ]
  ])
permission_set_managed_policy_map = { for permision_set in local.permission_set_managed_policy : "${permision_set.ps_name}.${permision_set.policy_arn}" => permision_set }

}



