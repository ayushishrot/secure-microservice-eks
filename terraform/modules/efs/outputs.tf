output "efs_id" {
  description = "The ID of the EFS file system created."
  value       = aws_efs_file_system.efs.id
}
