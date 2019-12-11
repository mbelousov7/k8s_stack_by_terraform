data "helm_repository" "loki" {
  name = "loki"
  url  = "https://grafana.github.io/loki/charts"
}

resource "helm_release" "grafana" {
    name  = "grafana"
    chart = "stable/grafana"
    namespace = "monitoring"
    set {
     name  = "ingress.enabled"
     value = "true"
    }
    set {
     name  = "adminPassword"
     value = "${var.grafana_password}"
    }
    set {
     name  = "ingress.hosts"
     value = "${var.grafana_hostname}"
    }
 }

resource "helm_release" "loki" {
    name  = "loki"
    chart = "loki/loki-stack"
    repository = data.helm_repository.loki.metadata[0].name
    namespace = "monitoring"
    set {
     name  = "grafana.enabled"
     value = "false"
    }
 }
