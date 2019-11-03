 resource "google_container_cluster" "k8s" {
  name = "k8scluster"
  location = "us-east1-b"
  min_master_version = "latest"
  initial_node_count = "1"


  master_auth {
    password = "password123P@ssw0rd"
    username = "username"
  }

  node_config {
    machine_type = "g1-small"
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      system = "monitoring"
    }

    tags = ["dev", "work", "epam", "vpn"]
  }
}
