locals {
  chris_amani = {
    sso_groups   = ["hashicorp"]
    display_name = "Chris Amani"
    emails = [
      {
        primary = true
        type    = "work"
        value   = "chris.amani@yahoo.com"
      },
    ]
    family_name   = "Chris"
    given_name    = "Amani"
    addresses     = []
    phone_numbers = []
  }

}
