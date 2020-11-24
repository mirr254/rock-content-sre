variable "monitoring_namespace" {
  default = "monitoring"
}

variable "app_namespace" {
  default = "app"
}

variable "admin_user" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "dashboard_yaml" {
  type    = string
  default = ""
}

variable "name" {
  type    = string
  default = "grafana"
}

variable "persistence_enabled" {
  type    = string
  default = "true"
}

variable "prometheus_service_endpoint" {
  type = string
}

variable "storage_class" {
  type    = string
  default = "default"
}

variable "storage_size" {
  type    = string
  default = "4Gi"
}