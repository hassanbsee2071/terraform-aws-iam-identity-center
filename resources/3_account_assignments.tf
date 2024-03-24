locals {
  account_assignments = [
    local.armon_dadgar_s3_full_access,
    // local.s3-tjwhotelcms,



    /////////////////////////////////////////////////////// GROUP ASSIGNMENT /////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    {
      principal_name = "hashicorp"
      principal_type = "GROUP"
      permission_set = "hashicorp-terraform-bucket"
      account_ids    = [local.accounts_mapping["hashicorp-aws"]]
    },

/*

    {
      principal_name = "sagemaker_poc"
      principal_type = "GROUP"
      permission_set = "sagemaker_poc"
      account_ids    = [local.accounts_mapping["hashicorp-aws"]]
    },

    {
      principal_name = "security-eng-aws-admin"
      principal_type = "GROUP"
      permission_set = "admin-access"
      account_ids    = [local.accounts_mapping["security-engineering-prod"]]
    },
*/

  ]
}
