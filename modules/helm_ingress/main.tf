

resource "helm_release" "nginx-ingress" {
    name  = "ingress"
    chart = "stable/nginx-ingress"
    namespace = "ingress"

    set {
     name  = "rbac.create"
     value = "true"
    }
    set {
     name  = "controller.kind"
     value = "DaemonSet"
    }
    set {
     name  = "controller.hostNetwork"
     value = "true"
    }
    set {
     name  = "controller.service.enabled"
     value = "false"
    }
    set {
     name  = "controller.extraArgs.report-node-internal-ip-address"
     value = "true"
    }
 }
