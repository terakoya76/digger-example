#-----------------------------------------
# NOTE:
# You must apply this file from local-machine at the initial setup
#-----------------------------------------
locals {
  oidc_service_account_id = "terraform"
  github_repositories = [
    "terakoya76/digger-example"
  ]
}

resource "google_service_account" "github" {
  project      = var.project_id
  account_id   = local.oidc_service_account_id
  display_name = local.oidc_service_account_id
}

resource "google_project_iam_member" "github" {
  project = var.project_id
  role    = "roles/owner"
  member  = google_service_account.github.member
}

resource "google_iam_workload_identity_pool" "github" {
  project                   = var.project_id
  workload_identity_pool_id = "github-actions"
  display_name              = "github-actions"
  description               = "Identity pool for GitHub Actions Dynamic Credentials integration"
}

resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions"
  display_name                       = "github-actions"
  description                        = "OIDC identity pool provider for GitHub Actions Dynamic Credentials integration"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.aud"        = "assertion.aud"
    "attribute.repository" = "assertion.repository"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "github" {
  for_each = toset(local.github_repositories)

  service_account_id = google_service_account.github.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${each.value}"
}
