resource "helm_release" "nginx-ingress" {
  name  = "nginx-ingress"
  chart = "stable/nginx-ingress"

  values = [<<EOF
rbac:
  create: false
EOF
  ]

}
