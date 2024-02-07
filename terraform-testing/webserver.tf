provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "test" {
  metadata {
    name = "nginx"
  }
}

resource "kubernetes_deployment" "test" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "MyTestApp"
      }
    }
    template {
      metadata {
        labels = {
          app = "MyTestApp"
        }
      }
      spec {
        container {
          image = "nginx"
          name  = "nginx-container"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "test" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.test.spec.0.template.0.metadata.0.labels.app
    }
    type = "NodePort"
    port {
      node_port   = 30201
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_network_policy" "test" {
  metadata {
    name = "test-network-policy"
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    pod_selector {
      match_labels = {
        app = "MyTestApp"
      }
    }
    policy_types = [ "Ingress", "Egress" ]
    ingress {
      from {
        ip_block {
          cidr = "192.168.122.0/24"
        }
      }
      ports {
        port = 1337
      }
    }
    egress {
      to {
        ip_block {
          cidr = "192.168.122.0/24"
        }
      }
      ports {
        port = 1337
      }
    }
  }
}
