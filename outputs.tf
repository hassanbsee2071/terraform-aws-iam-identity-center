
output "map_of_users_containing_sso_group" {
  value = local.map_of_users_containing_sso_group
}

output "mapping_of_sso_users_with_groups" {
  value = local.mapping_of_sso_users_with_groups
}


output "assignment_of_user_to_groups" {
  value = local.assignment_of_user_to_groups
}


output "inline_policy_if_present" {
  value = local.inline_policy_if_present
}


output "customer_managed_ps" {
  value = local.customer_managed_ps
}

output "customer_ps_policy_maps" {
  value = local.customer_ps_policy_maps
}

output "customer_managed_policy_map" {
  value = local.customer_managed_policy_map
}


output "users_list" {
  value = local.users_list
}


output "groups_list" {
  value = local.groups_list
}


output "unique_users_list" {
  value = local.unique_users_list
}



output "unique_groups_list" {
  value = local.unique_groups_list
}


output "permission_set_managed_policy" {
  value = local.permission_set_managed_policy
}



output "managed_ps" {
  value = local.managed_ps
}


output "permission_set_managed_policy_map" {
  value = local.permission_set_managed_policy_map
}


output "groups_assignment" {
  value = local.groups_assignment
}


output "users_assignment" {
  value = local.users_assignment
}


