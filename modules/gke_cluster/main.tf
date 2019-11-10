resource "google_container_cluster" "cluster" {
  provider = "google-beta"

  name        = var.name
  description = var.description

  project    = var.project
  location   = var.location


  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service

  remove_default_node_pool = false
  initial_node_count = 1

  node_config {
    image_type   = "COS"
    machine_type = "n1-standard-1"

    disk_size_gb = "30"
    disk_type    = "pd-standard"

#    preemptible  = false
#    service_account = google_service_account.cluster_service_account.email

  oauth_scopes = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
  ]

    labels = {
      system = "laba"
    }

    tags = ["dev", "work", "epam", "vpn"]
  }

  addons_config {
    http_load_balancing {
      disabled = ! var.http_load_balancing
    }

    kubernetes_dashboard {
      disabled = ! var.enable_kubernetes_dashboard
    }

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
