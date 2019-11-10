 resource "google_container_cluster" "k8s" {
  name = var.k8s_cluster_name
  location = var.k8s_cluster_location
  min_master_version = "latest"
  initial_node_count = "1"
  logging_service = "none"
  monitoring_service = "none"

  master_auth {
    password = var.k8s_cluster_password
    username = var.k8s_cluster_user
  }
  addons_config {
    kubernetes_dashboard {
      disabled = false
    }
  }
  node_config {
    machine_type = "g1-small"
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]

    labels = {
      system = "monitoring"
    }

    tags = ["dev", "work", "epam", "vpn"]
  }
}
