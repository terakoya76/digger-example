terraform {
  required_version = ">= 1.8.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    region         = "ap-northeast-1"
    bucket         = "my-example-bucket" # creating from outside terraform management
    key            = "tfstate/account_a"
    dynamodb_table = "account-b-tfstate-state-lock" # creating from outside terraform management
    encrypt        = "true"
    profile        = "account-b"
  }
}

provider "aws" {
  region              = var.region
  allowed_account_ids = [var.account_id]
  profile             = var.profile
}
