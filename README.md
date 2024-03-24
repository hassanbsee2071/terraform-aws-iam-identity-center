# Terraform AWS IAM Identity Center              (AWS SSO)

At **Almosafer,** we utilize the IAM Identity Center to manage our growing user base. As our user  expands rapidly, we recognized the need to streamline our infrastructure management process. We explored the possibility of implementing infrastructure as code using Terraform. However, upon evaluation, we discovered that there was no existing module capable of handling the creation of users, groups, permission sets, account assignments, and group assignments within a single Terraform Module.

While there were separate modules available for each aspect of IAM management, integrating them required executing multiple Terraform modules. I decided to develop a unified Terraform module that would facilitate the creation and management of all these resources. 

This module will provisioning users, groups, permission sets, account assignments, and group assignments with single module.

# Requirement
Create a user **armon.dadgar** and assign full access to S3. Create a group called **hashicorp** and add **armon.dadgar** to the group. Group should have permission to only list object for bucket called terraform. Both entities have access to only account number **012345678901**

# Resources:

 1. Sample resources are created  under resources folder inside the repo.
 2. No need to change in 1_main.tf. 
 3. Create a file called 2_users.tf
```
locals {
sso_users =  {
"armon.dadgar@yahoo.com" = local.armon_dadgar,
"chris.amani@yahoo.com"  = local.chris_amani
             }
}
```
4. Create a file called 4_groups.tf
```
locals {

sso_groups_okta =  {
"travel-readonly" = {},
"DevOps" = {}
"ReadOnly" = {
description = "Read Only group"
             }
hashicorp =  {
description = "Full Access to bucket named terraform"
             }
                    }
 }
```
5. Create a file called 5_permission_set.tf.
```
locals {
permission_sets =  {
hashicorp-terraform-bucket = {
inline_policy = "${file("./policies/inline/hashicorp-terrafor-bucket.json")}"
},
armon-dadgar = {
managed_policies = ["arn:aws:iam::aws:policy/AmazonS3FullAccess"],
session_duration = "PT12H",
},
/*
data-athena-full-access = {
inline_policy = "${file("./policies/inline/data-athena-full-access.json")}"
managed_policies = ["arn:aws:iam::aws:policy/AmazonAthenaFullAccess", "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess", "arn:aws:iam::aws:policy/AWSLambda_FullAccess", "arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess", "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"]
session_duration = "PT12H",
},
edl-stage-de-amazon-q-access = {
session_duration = "PT12H"
managed_policies = ["arn:aws:iam::aws:policy/AmazonQFullAccess"],
inline_policy = "${file("./policies/inline/edl-stage-de-amazon-q-access.json")}"
}
*/
}
}
```
6. Create a folder policies/inline.
7. Create a file inside policies/inline/hashicorp-terrafor-bucket.json
```
{
"Version": "2012-10-17",
"Statement": [
{
"Sid": "VisualEditor0",
"Effect": "Allow",
"Action": [
"s3:GetObject",
"s3:ListBucket"
],
"Resource": [
"arn:aws:s3:::terraform",
"arn:aws:s3:::terraform/*"
]
},
{
"Sid": "VisualEditor1",
"Effect": "Allow",
"Action": [
"s3:GetBucketLocation",
"s3:ListAllMyBuckets"
],
"Resource": "*"
}
]
}
```
8. Create a file called user_01_armon_dadgar.tf.
```
locals {
armon_dadgar =  {
sso_groups  = ["hashicorp"]  /// This will add armon.dadgar to hashicorp group //////
display_name = "Armon Dadgar"
emails = [
{
primary = true
type  = "work"
value  = "armon.dadgar@yahoo.com"
},
]
family_name  = "Armon"
given_name  = "Dadgar"
addresses  = []
phone_numbers = []
}
///////// Single User Access, only providing access to armon.dadgar /////////
armon_dadgar_s3_full_access =  {
principal_name = "armon.dadgar@yahoo.com"
principal_type = "USER"
permission_set = "armon-dadgar"
account_ids  = [local.accounts_mapping["hashicorp-aws"]]
}
}
```
9. Create a file called 3_account_assignments.tf
```
locals {
account_assignments =  [
local.armon_dadgar_s3_full_access,
// local.s3-tjwhotelcms,

/////////////////////////////////////////////////////// GROUP ASSIGNMENT ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

{
principal_name = "hashicorp"
principal_type = "GROUP"
permission_set = "hashicorp-terraform-bucket"
account_ids  = [local.accounts_mapping["hashicorp-aws"]]
},
/*
{
principal_name = "sagemaker_poc"
principal_type = "GROUP"
permission_set = "sagemaker_poc"
account_ids = [local.accounts_mapping["hashicorp-aws"]]
},
{
principal_name = "security-eng-aws-admin"
principal_type = "GROUP"
permission_set = "admin-access"
account_ids = [local.accounts_mapping["security-engineering-prod"]]
},
*/
]
}
``` 
10. Do not change anything in data.tf file
11. Change your backend.tf file accordingly.
