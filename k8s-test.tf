resource "kubernetes_namespace" "laba" {
  metadata {
    name = "laba"
  }
}

resource "kubernetes_pod" "nginx" {
  metadata {
    name = "nginx-example"
    namespace = "laba"
    labels = {
      App = "nginx"
    }
  }

  spec {
    container {
      image = "nginx:1.7.8"
      name  = "example1"

      port {
        container_port = 80
      }
    }
  }
  depends_on = [google_container_cluster.cluster]
}



resource "helm_release" "nginx-helm" {
  name  = "nginx-helm"
  chart = "bitnami/nginx"
  namespace = "laba"
}
