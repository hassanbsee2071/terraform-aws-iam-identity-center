locals {
  armon_dadgar = {
    sso_groups   = ["hashicorp"]  /// This will add armon.dadgar to hashicorp group //////
    display_name = "Armon Dadgar"
    emails = [
      {
        primary = true
        type    = "work"
        value   = "armon.dadgar@yahoo.com"
      },
    ]
    family_name   = "Armon"
    given_name    = "Dadgar"
    addresses     = []
    phone_numbers = []
  }


/////////  Single User Access, only providing access to armon.dadgar /////////
  armon_dadgar_s3_full_access = {
    principal_name = "armon.dadgar@yahoo.com"
    principal_type = "USER"
    permission_set = "armon-dadgar"
    account_ids    = [local.accounts_mapping["hashicorp-aws"]]

  }


}
