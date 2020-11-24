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
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts" 
  chart      = "prometheus"
  namespace  = kubernetes_namespace.monitoring_namespace.id

}

resource "kubernetes_storage_class" "sc" {
  metadata {
    name = "terraform-sc"
  }
  storage_provisioner = "k8s.io/minikube-hostpath"
  reclaim_policy      = "Retain"
}

data "template_file" "template_grafana_yaml" {
  template = file("${path.module}/values.yaml.tmpl")

  vars = {
    dashboard_yaml              = var.dashboard_yaml
    persistence_enabled         = var.persistence_enabled
    prometheus_service_endpoint = var.prometheus_service_endpoint
    storage_class               = kubernetes_storage_class.sc.metadata.0.name
    storage_size                = var.storage_size
  }
}

resource "null_resource" "generate_grafana_yaml" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.template_grafana_yaml.rendered}' > ${path.module}/values.yaml"
  }
}

resource "helm_release" "grafana" {
  name       = "grafana-release"
  repository = "https://grafana.github.io/helm-charts" 
  chart      = "grafana"
  namespace  = kubernetes_namespace.monitoring_namespace.id

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "adminUser"
    value = var.admin_user
  }

  set {
    name  = "adminPassword"
    value = var.admin_password
  }

  set {
    name  = "persistance_enabled"
    value = var.persistence_enabled
  }

  set {
    name  = "persistance_storage_class"
    value = var.storage_class
  }

}

resource "helm_release" "local_deploy_chart" {
  name       = "wp-rock-chart"
  chart      = "../wp-rock-sre"
  namespace  = kubernetes_namespace.app_namespace.id
}
