terraform {
  required_version = ">= 0.12.13"
}

provider "google" {
  project = var.project
  region  = var.location
#  credentials = "mbelousov-terraform-prod2.json"
  credentials = "${file("${var.file_account}")}"
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

resource "google_project_service" "service" {
  count   = length(var.project_services)
  project = var.project
  service = element(var.project_services, count.index)

  # Do not disable the service on destroy. On destroy, we are going to
  # destroy the project, but we need the APIs available to destroy the
  # underlying resources.
  disable_on_destroy = false
}

#Test account check
resource "google_compute_network" "our_development_network" {
  name = "terraform-network-${terraform.workspace}"
  auto_create_subnetworks = false
}

data "google_client_config" "current" {}

module "gke_cluster" {
  source = "./modules/gke_cluster"
  project = var.project
  location = var.location
  cluster_name = "gke-cluster-${terraform.workspace}"
}

provider "kubernetes" {
  version = "~> 1.7.0"
  load_config_file       = false
#  host                   = google_container_cluster.cluster.endpoint
#  cluster_ca_certificate = base64decode(google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
  host                   = module.gke_cluster.endpoint
  cluster_ca_certificate = module.gke_cluster.cluster_ca_certificate
  token                  = data.google_client_config.current.access_token
}


module "helm_init" {
  source = "./modules/helm_init"
  cluster_name = module.gke_cluster.name
}

#HELM config

provider "helm" {
  install_tiller  = true
  service_account = "tiller"
  namespace       = "kube-system"

  kubernetes {
    host                   = module.gke_cluster.endpoint
    token                  = "${data.google_client_config.current.access_token}"
    client_certificate     = module.gke_cluster.client_certificate
    client_key             = module.gke_cluster.client_key
    cluster_ca_certificate = module.gke_cluster.cluster_ca_certificate
  }
}

module "helm_ingress" {
  source = "./modules/helm_ingress"
  tiller = module.helm_init.tiller
}

module "helm_loki" {
  source = "./modules/helm_loki"
  grafana_hostname = var.loki_hostname
  grafana_password = var.grafana_password
  tiller = module.helm_init.tiller
}


module "helm_prometheus" {
  source = "./modules/helm_prometheus"
  grafana_hostname = var.grafana_hostname
  grafana_password = var.grafana_password
  tiller = module.helm_init.tiller
#  helm_prometheus_version = var.helm_prometheus_version
}

# configure kubectl with the credentials of the GKE cluster
resource "null_resource" "configure_kubectl" {
  provisioner "local-exec" {
    command = "gcloud beta container clusters get-credentials gke-cluster-${terraform.workspace} --region ${var.location} --project ${var.project}"

    # Use environment variables to allow custom kubectl config paths
    environment = {
      KUBECONFIG = var.kubectl_config_path != "" ? var.kubectl_config_path : ""
    }
  }

  depends_on = [
    module.gke_cluster
  ]
}
