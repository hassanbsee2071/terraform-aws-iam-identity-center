variable "sso_users" {
  description = "Map of maps containing Permission Set names as keys. See permission_sets description in README for information about map values."
  type        = any
  default = {
      display_name       = "Tom Character"
      given_name         = "Tom"
      family_name        = "Cartoon Network"
      sso_groups         = ["eks", "ec2"]
      locale             = "Locale"
      nickname           = "tom"
      preferred_language = "English"
      profile_url        = "NA"
      timezone           = "NA"
      title              = "Mr"
      user_type          = "NA"

      emails = [
        {
          value   = "tom.cartoon@seera.sa"
          primary = true
          type    = "work"
        },
      ]
      addresses = [
        {
          country        = "UAE"
          formatted      = "Formatted address"
          locality       = "UAE"
          postal_code    = "NA"
          primary        = true
          region         = "Middel East"
          street_address = "Al Nahda Street 1"
          type           = "work"
        },
      ]
      phone_numbers = [
        {
          value   = "0585735109"
          primary = true
          type    = "work"
        },
      ]
    }
}


variable "permission_sets" {
  description = "Map of maps containing Permission Set names as keys. See permission_sets description in README for information about map values."
  type        = any
  default = {
    ViewOnlyAccess = {
      description      = "View resources and basic metadata across all AWS services.",
      session_duration = "PT2H",
      managed_policies = ["arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"]
    }
  }
}

variable "sso_groups_okta" {
  description = "A map of AWS SSO groups"
  type = map(object({
    description = optional(string)
  }))
  default = {}
}


variable "account_assignments" {
  description = "List of maps containing mapping between user/group, permission set and assigned accounts list. See account_assignments description in README for more information about map values."
  type = list(object({
    principal_name = string,
    principal_type = string,
    permission_set = string,
    account_ids    = list(string),

  }))

  default = []
}

variable "aws_region" {
   default = "eu-west-1"  
}

variable "aws_profile" {
  
}




