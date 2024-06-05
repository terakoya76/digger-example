resource "google_service_account" "test" {
  project      = var.project_id
  account_id   = "test-sa"
  display_name = "test-sa"
}
