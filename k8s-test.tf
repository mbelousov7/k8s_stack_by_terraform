resource "kubernetes_namespace" "laba" {
  metadata {
    name = "laba"
  }
}
#pod tests
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
  depends_on = [null_resource.configure_kubectl]
}

#ingress test
resource "kubernetes_ingress" "example_ingress" {
  metadata {
    name = "example-ingress"
    namespace = "laba"
  }

  spec {
    rule {
      http {
        path {
          backend {
            service_name = "example-service"
            service_port = 8080
          }

          path = "/"
        }
      }
    }

  }
}

resource "kubernetes_service" "example" {
  metadata {
    name = "example-service"
    namespace = "laba"
  }
  spec {
    selector = {
      app = "${kubernetes_pod.example.metadata.0.labels.app}"
    }
#    session_affinity = "ClientIP"
    port {
      port        = 8080
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_pod" "example" {
  metadata {
    name = "example-pod"
    labels = {
      app = "myapp"
    }
  }

  spec {
    container {
      image = "nginx:1.7.9"
      name  = "example"
    }
  }
}
