provider "helm" {
  kubernetes {
        config_context_cluster   = "minikube"
  }
}

resource "kubernetes_namespace" "monitoring_namespace" {
  metadata {
        name = "monitoring"
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus-release"
  repository = "https://prometheus-community.github.io/helm-charts" 
  chart      = "prometheus"
  namespace  = kubernetes_namespace.monitoring_namespace.id

}

resource "helm_release" "grafana" {
  name       = "grafana-release"
  repository = "https://grafana.github.io/helm-charts" 
  chart      = "grafana"
  namespace  = kubernetes_namespace.monitoring_namespace.id

  # values = [
  #   "${file("values.yaml")}"
  # ]

}