resource "aws_secretsmanager_secret" "this" {
  count       = var.create_secret ? 1 : 0
  name        = var.secret_name
  description = var.secret_description
  kms_key_id  = var.kms_key_id
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this[0].id
  secret_string = var.secret_string
}
