# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "grafana_hostname" {
  description = "grafana_hostname"
}

variable "grafana_password" {
  description = "grafana_password"
}


# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "helm_prometheus_version" {
  description = "helm_prometheus_version"
  default     = "6.20.2"
}

#for module dependency
variable "tiller" {
  description = "The name helm tiller instance"
}
