resource "kubernetes_namespace" "web_app" {
  metadata {
    name = "secrets-manager"
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "helm_release" "web_app" {
  name       = "secret-manager"
  namespace  = kubernetes_namespace.web_app.metadata[0].name
  chart      = "${path.module}/../../helm"
  version    = "0.1.0"

  values = [file("${path.module}/../../../helm/values.yaml")]

  set = [
    {
      name  = "env.NODE_ENV"
      value = "production"
    }
  ]

  set_sensitive = [
    {
      name  = "env.MONGODB_URI"
      value = format(
        "mongodb://%s:%s@%s:%s/%s?retryWrites=true&w=majority",
        module.documentdb.docdb_cluster_endpoint
      )
    }
  ]

  depends_on = [
    module.documentdb,
    data.aws_secretsmanager_secret_version.docdb_secret_version
  ]
}
