
# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A PRIVATE CLUSTER IN GOOGLE CLOUD PLATFORM
# ---------------------------------------------------------------------------------------------------------------------

resource "google_container_cluster" "cluster" {

  name        = var.cluster_name
  description = var.description
  project    = var.project
  location   = var.location
  min_master_version = var.kubernetes_version

  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service

  remove_default_node_pool = false
  initial_node_count = 2

  node_config {
#    service_account = "terraform@mbelousov-terraform.iam.gserviceaccount.com"
    image_type   = "COS"
    machine_type = "n1-standard-1"

    disk_size_gb = "30"
    disk_type    = "pd-standard"

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      pool = "init"
    }

  }

  addons_config {
    http_load_balancing {
      disabled = ! var.http_load_balancing
    }

#    kubernetes_dashboard {
#      disabled = ! var.enable_kubernetes_dashboard
#    }

  }

  master_auth {
    # Setting an empty username and password explicitly disables basic auth
    username = ""
    password = ""

    # Whether client certificate authorization is enabled for this cluster.
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}
