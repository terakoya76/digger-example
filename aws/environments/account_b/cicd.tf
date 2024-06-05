#-----------------------------------------
# NOTE:
# You must apply this file from local-machine at the initial setup
#-----------------------------------------
locals {
  oidc_iam_role_name = "terraform"
  github_repositories = [
    "terakoya76/digger-example"
  ]
}

resource "aws_dynamodb_table" "digger_lock_table" {
  # This naming is from a specification of digger
  # cf. https://github.com/diggerhq/digger/blob/fa5b2b3c7fbf4819f74501903d8af8c6034b6b6c/cli/pkg/aws/dynamo_locking.go#L16
  name         = "DiggerDynamoDBLockTable"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "PK"
  range_key = "SK"

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }
}

module "oidc_github_aws" {
  source  = "unfunco/oidc-github/aws"
  version = "1.8.0"

  iam_role_name       = local.oidc_iam_role_name
  attach_admin_policy = true

  create_oidc_provider   = true
  additional_thumbprints = []

  github_repositories = local.github_repositories
}
