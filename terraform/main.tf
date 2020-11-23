provider "helm" {
  kubernetes {
        config_context_cluster   = "minikube"
  }
}

resource "kubernetes_namespace" "monitoring_namespace" {
  metadata {
        name = var.monitoring_namespace
  }
}

resource "kubernetes_namespace" "app_namespace" {
  metadata {
        name = var.app_namespace
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

resource "helm_release" "local_deploy_chart" {
  name       = "wp-rock-chart"
  chart      = "../wp-rock-sre"
  namespace  = kubernetes_namespace.app_namespace.id
}

#use this module to get the grafana password from Secret store
# module "grafana_password" {
#   source    = "gearnode/get-secret/kubernetes"
#   version   = "0.3.1"
#   namespace = kubernetes_namespace.monitoring_namespace.id
#   name      = "grafana"
#   key       = "admin-password"
#   context   = "minikube"

#   depends_on  = [helm_release.grafana]
# }
