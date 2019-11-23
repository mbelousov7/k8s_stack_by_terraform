

resource "template_file" "prometheus_helm_values_tmpl" {
    template = "${file("${path.module}/resources/prometheus-operator.values-tmpl.yaml")}"
    vars = {
      grafana_hostname = "${var.grafana_hostname}"
      grafana_password = "${var.grafana_password}"
    }
}

resource "local_file" "prometheus_helm_values" {
    content = "${template_file.prometheus_helm_values_tmpl.rendered}"
    filename = "${path.module}/resources/prometheus-operator.values.yaml"
}

resource "helm_release" "prometheus-operator" {
    name  = "prom"
    chart = "stable/prometheus-operator"
# use if needed not last version    
#    version = var.helm_prometheus_version
    namespace = "monitoring"

    values = [
      "${file("${path.module}/resources/prometheus-operator.values.yaml")}"
    ]
    depends_on = [local_file.prometheus_helm_values]
 }
