resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}


 resource "helm_release" "prometheus-operator" {
   name  = "prom"
   chart = "stable/prometheus-operator"
   namespace = "monitoring"

   set {
    name  = "grafana.service.type"
    value = "LoadBalancer"
   }

   set {
    name  = "grafana.adminPassword"
    value = var.password
   }

   values = [
    "${file("helm/prometheus-operator.values.yaml")}"
   ]
  depends_on = [null_resource.configure_kubectl]
 }
