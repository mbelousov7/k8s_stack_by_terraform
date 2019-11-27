


resource "google_service_account" "terraform-sa" {
  account_id   = "terraform-sa"
  display_name = "terraform-sa"
  project      = var.project
}

# Create a service account key
resource "google_service_account_key" "terraform" {
  service_account_id = google_service_account.terraform-sa.name
}

# Enable required services on the project
resource "google_project_service" "service" {
  count   = length(var.project_services)
  project = var.project
  service = element(var.project_services, count.index)

  # Do not disable the service on destroy. On destroy, we are going to
  # destroy the project, but we need the APIs available to destroy the
  # underlying resources.
  disable_on_destroy = false
}

# Add the service account to the project
#resource "google_project_iam_member" "service-account" {
#  count   = length(var.service_account_iam_roles)
#  project = var.project
#  role    = element(var.service_account_iam_roles, count.index)
#  member  = "serviceAccount:${google_service_account.terraform-sa.email}"
#}

#resource "google_project_iam_member" "project" {
#  project = var.project
#  role    = "roles/editor"
#  member  = "serviceAccount:terraform-sa3@terraform2-258719.iam.gserviceaccount.com"
#}
