locals {
  sso_groups_okta = {

/*
    "travel-readonly"   = {},
    "DevOps"       = {}
    "ReadOnly" = {
      description = "Read Only group"
    }

*/
    hashicorp = {
      description = "Full Access to bucket named terraform"
    }

  }
}
