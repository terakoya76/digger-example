terraform {
  required_version = ">= 1.8.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    region         = "ap-northeast-1"
    bucket         = "my-example-bucket" # creating from outside terraform management
    key            = "tfstate/project_a"
    dynamodb_table = "account-a-tfstate-state-lock" # creating from outside terraform management
    encrypt        = "true"
    profile        = "account-a"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}
