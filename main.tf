terraform {
  required_version = ">= 0.12.13"
}

provider "google" {
  project = var.project
  region  = var.location
  credentials = "${file("${var.file_account}")}"
#  credentials = "${file("terraform-admin.json")}"
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


data "google_client_config" "current" {}


provider "kubernetes" {
  version = "~> 1.7.0"
  load_config_file       = false
  host                   = google_container_cluster.cluster.endpoint
  token                  = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
}

module "helm_init" {
  source = "./modules/helm_init"
}

#HELM config
provider "helm" {
  install_tiller  = true
  service_account = "tiller"
  namespace       = "kube-system"

  kubernetes {
    host                   = "${google_container_cluster.cluster.endpoint}"
    token                  = "${data.google_client_config.current.access_token}"
    client_certificate     = "${base64decode(google_container_cluster.cluster.master_auth.0.client_certificate)}"
    client_key             = "${base64decode(google_container_cluster.cluster.master_auth.0.client_key)}"
    cluster_ca_certificate = "${base64decode(google_container_cluster.cluster.master_auth.0.cluster_ca_certificate)}"
  }
}


# configure kubectl with the credentials of the GKE cluster
resource "null_resource" "configure_kubectl" {
  provisioner "local-exec" {
    command = "gcloud beta container clusters get-credentials ${google_container_cluster.cluster.name} --region ${var.location} --project ${var.project}"

    # Use environment variables to allow custom kubectl config paths
    environment = {
      KUBECONFIG = var.kubectl_config_path != "" ? var.kubectl_config_path : ""
    }
  }

  depends_on = [
    google_container_cluster.cluster,
    google_container_node_pool.node_pool_main,
    module.helm_init
  ]
}

module "helm_ingress" {
  source = "./modules/helm_ingress"
}

module "helm_loki" {
  source = "./modules/helm_loki"
}

module "helm_prometheus" {
  source = "./modules/helm_prometheus"
  grafana_hostname = var.grafana_hostname
  grafana_password = var.grafana_password
  helm_prometheus_version = var.helm_prometheus_version
}
