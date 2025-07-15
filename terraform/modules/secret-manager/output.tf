output "secret_arn" {
  description = "The ARN of the secret"
  value       = aws_secretsmanager_secret.this[0].arn
}

output "secret_name" {
  description = "The name of the secret"
  value       = aws_secretsmanager_secret.this[0].name
}

output "secret_id" {
  description = "The ID of the secret"
  value       = aws_secretsmanager_secret.this[*].id
}
