provider "google" {
  credentials = "${file("../myVPS/terraform-gcp-account.json")}"
  project = var.gcp_project_id
  region = var.gcp_location
}


data "google_client_config" "default" {}

data "google_container_cluster" "my_cluster" {
  name   = var.k8s_cluster_name
  zone   = var.k8s_cluster_location
  depends_on = [google_container_cluster.k8s]
}

provider "kubernetes" {
  load_config_file = false

  host = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token = "${data.google_client_config.default.access_token}"
  cluster_ca_certificate = "${base64decode(data.google_container_cluster.my_cluster.master_auth.0.cluster_ca_certificate)}"
}
