# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ------------------------------------------------------------------------------


variable "project" {
  description = "The project ID where all resources will be launched."
  type        = string
}


variable "location" {
  description = "The location (region or zone) of the GKE cluster."
  type        = string
}


# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ------------------------------------------------------------------------------

variable "cluster_name" {
  description = "The name of the Kubernetes cluster."
  type        = string
  default     = "example-cluster"
}

variable "cluster_service_account_name" {
  description = "The name of the custom service account used for the GKE cluster. This parameter is limited to a maximum of 28 characters."
  type        = string
  default     = "example-cluster-sa"
}

variable "cluster_service_account_description" {
  description = "A description of the custom service account used for the GKE cluster."
  type        = string
  default     = "Example GKE Cluster Service Account managed by Terraform"
}

# Kubectl options

variable "kubectl_config_path" {
  description = "Path to the kubectl config file. Defaults to $HOME/.kube/config"
  type        = string
  default     = ""
}
