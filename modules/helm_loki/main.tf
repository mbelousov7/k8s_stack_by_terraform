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
     value = "strongpassword"
    }
    set {
     name  = "ingress.hosts"
     value = "{grafanaloki.terraformk8s.com}"
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
