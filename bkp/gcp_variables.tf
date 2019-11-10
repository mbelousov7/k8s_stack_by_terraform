variable "gcp_project_credentials_file" {
  type = string
  default = "terraform-gcp-account.json"
  description = <<EOF
The ID of the project in which the resources belong.
EOF
}

variable "gcp_project_id" {
  type = string
  default = "project_id"
  description = <<EOF
The ID of the project in which the resources belong.
EOF
}

variable "cluster_name" {
  type = string
  default = "k8scluster"
  description = <<EOF
The name of the cluster, unique within the project and zone.
EOF
}

variable "gcp_location" {
  type = string
  default = "us-east1-b"
  description = <<EOF
The gcp location of cluster, default us-east1-b
EOF
}


//Outputs

output "cluster_location" {
  value = "${data.google_container_cluster.k8s.location}"
}

output "cluster_username" {
  value = "${data.google_container_cluster.k8s.master_auth.0.username}"
}

output "cluster_password" {
  value = "${data.google_container_cluster.k8s.master_auth.0.password}"
}

output "endpoint" {
  value = "${data.google_container_cluster.k8s.endpoint}"
}

output "instance_group_urls" {
  value = "${data.google_container_cluster.k8s.instance_group_urls}"
}

output "node_config" {
  value = "${data.google_container_cluster.k8s.node_config}"
}

output "node_pools" {
  value = "${data.google_container_cluster.k8s.node_pool}"
}
