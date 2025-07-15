resource "kubernetes_namespace" "image_api" {
  metadata {
    name = "web-app"
    labels = {
      environment = var.environment
    }
  }
}
