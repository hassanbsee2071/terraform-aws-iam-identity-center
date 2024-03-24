terraform {
  backend "s3" {
    bucket         = "your-bucket-name"
    key            = "your-bucket-name/resources/aws-sso/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "your-dynamodb-table"
    profile        = "your-aws-profile-name" #this profile is only used for s3 backend
  }
}
