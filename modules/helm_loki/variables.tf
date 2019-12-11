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

#for module dependency
variable "tiller" {
  description = "The name helm tiller instance"
}
