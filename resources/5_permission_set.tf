locals {
  permission_sets = {


    hashicorp-terraform-bucket = {
      inline_policy = "${file("./policies/inline/hashicorp-terrafor-bucket.json")}"
    },

    armon-dadgar = {
      managed_policies = ["arn:aws:iam::aws:policy/AmazonS3FullAccess"],
      session_duration = "PT12H",
    },

/*

    data-athena-full-access = {
      inline_policy    = "${file("./policies/inline/data-athena-full-access.json")}"
      managed_policies = ["arn:aws:iam::aws:policy/AmazonAthenaFullAccess", "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess", "arn:aws:iam::aws:policy/AWSLambda_FullAccess", "arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess", "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"]
      session_duration = "PT12H",
    },

    edl-stage-de-amazon-q-access = {
      session_duration = "PT12H"
      managed_policies = ["arn:aws:iam::aws:policy/AmazonQFullAccess"],
      inline_policy    = "${file("./policies/inline/edl-stage-de-amazon-q-access.json")}"
    }
*/

  }

}
