resource "kubernetes_namespace_v1" "demo" {
  metadata {
    name = "demo"
  }
}

resource "kubernetes_deployment_v1" "echo" {
  metadata {
    name      = "echo-app"
    namespace = kubernetes_namespace_v1.demo.metadata[0].name
    labels = {
      app = "echo-app"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "echo-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "echo-app"
        }
      }

      spec {
        node_selector = {
          workload = "app"
        }

        container {
          name  = "echo"
          image = "hashicorp/http-echo:1.0.0"

          args = [
            "-text=hello-from-$(HOSTNAME)"
          ]

          env {
            name = "HOSTNAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          port {
            container_port = 5678
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "echo" {
  metadata {
    name      = "echo-svc"
    namespace = kubernetes_namespace_v1.demo.metadata[0].name
    labels = {
      app = "echo-app"
    }
  }

  spec {
    selector = {
      app = "echo-app"
    }

    port {
      port        = 80
      target_port = 5678
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "echo" {
  metadata {
    name      = "echo-ingress"
    namespace = kubernetes_namespace_v1.demo.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"                = "alb"
      "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"      = "ip"
      "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\":80}]"
      "alb.ingress.kubernetes.io/healthcheck-path" = "/"
    }
  }

  spec {
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.echo.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.aws_load_balancer_controller]
}
