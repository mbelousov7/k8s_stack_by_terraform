terraform {
  required_version = ">= 0.12.13"
}

provider "google" {
  project = var.project
  region  = var.location

  scopes = [
    # Default scopes
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
    "https://www.googleapis.com/auth/devstorage.full_control",

    # Required for google_client_openid_userinfo
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

provider "google-beta" {
  project = var.project
  region  = var.location

  scopes = [
    # Default scopes
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
    "https://www.googleapis.com/auth/devstorage.full_control",

    # Required for google_client_openid_userinfo
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

data "google_client_config" "client" {}

data "template_file" "gke_host_endpoint" {
  template = module.gke_cluster.endpoint
}

data "template_file" "access_token" {
  template = data.google_client_config.client.access_token
}

data "template_file" "cluster_ca_certificate" {
  template = module.gke_cluster.cluster_ca_certificate
}

provider "kubernetes" {
  version = "~> 1.7.0"

  load_config_file       = false
  host                   = data.template_file.gke_host_endpoint.rendered
  token                  = data.template_file.access_token.rendered
  cluster_ca_certificate = data.template_file.cluster_ca_certificate.rendered
}


# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A PRIVATE CLUSTER IN GOOGLE CLOUD PLATFORM
# ---------------------------------------------------------------------------------------------------------------------

module "gke_cluster" {
  source = "./modules/gke_cluster"
  name = var.cluster_name
  project  = var.project
  location = var.location

}


# ------------------------------------------------------------------------------
# CREATE A NODE POOL
# ------------------------------------------------------------------------------

resource "google_container_node_pool" "node_pool" {
  provider = google-beta

  name     = "main-pool"
  project  = var.project
  location = var.location
  cluster  = module.gke_cluster.name

  initial_node_count = "1"
  node_config {
    image_type   = "COS"
    machine_type = "n1-standard-1"

    disk_size_gb = "30"
    disk_type    = "pd-standard"
#    preemptible  = false

#    service_account = google_service_account.cluster_service_account.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = {
      system = "monitoring"
    }

    tags = ["dev", "work", "epam", "vpn"]
  }

}
