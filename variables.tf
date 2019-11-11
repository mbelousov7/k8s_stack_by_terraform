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

# Kubectl options

variable "kubectl_config_path" {
  description = "Path to the kubectl config file. Defaults to $HOME/.kube/config"
  type        = string
  default     = ""
}

# Cluster options
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

variable "description" {
  description = "The description of the cluster"
  type        = string
  default     = ""
}

variable "kubernetes_version" {
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region."
  type        = string
  default     = "latest"
}

variable "logging_service" {
  description = "The logging service that the cluster should write logs to. Available options include logging.googleapis.com/kubernetes, logging.googleapis.com (legacy), and none"
  type        = string
  default     = "none"
}

variable "monitoring_service" {
  description = "The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Stackdriver Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting. Available options include monitoring.googleapis.com/kubernetes, monitoring.googleapis.com (legacy), and none"
  type        = string
  default     = "none"
}

variable "http_load_balancing" {
  description = "Whether to enable the http (L7) load balancing addon"
  type        = bool
  default     = true
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS - RECOMMENDED DEFAULTS
# ------------------------------------------------------------------------------

variable "enable_kubernetes_dashboard" {
  description = "Whether to enable the Kubernetes Web UI (Dashboard). The Web UI requires a highly privileged security account."
  type        = bool
  default     = false
}

variable "basic_auth_username" {
  description = "The username used for basic auth; set both this and `basic_auth_password` to \"\" to disable basic auth."
  type        = string
  default     = ""
}

variable "basic_auth_password" {
  description = "The password used for basic auth; set both this and `basic_auth_username` to \"\" to disable basic auth."
  type        = string
  default     = ""
}
