provider "google" {
  project = var.project
  region  = var.location
}

provider "google-beta" {
  project = var.project
  region  = var.location
}


resource "google_service_account" "terraform" {
  account_id   = "terraform"
  display_name = "terraform"
  project      = var.project
}

# Create a service account key
resource "google_service_account_key" "terraform" {
  service_account_id = google_service_account.terraform.name
}


# Add the service account to the project
resource "google_project_iam_member" "service-account" {
  count   = length(var.service_account_iam_roles)
  project = var.project
  role    = element(var.service_account_iam_roles, count.index)
  member  = "serviceAccount:${google_service_account.terraform.email}"
}

# Add user-specified roles
resource "google_project_iam_member" "service-account-custom" {
  count   = length(var.service_account_custom_iam_roles)
  project = var.project
  role    = element(var.service_account_custom_iam_roles, count.index)
  member  = "serviceAccount:${google_service_account.terraform.email}"
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
