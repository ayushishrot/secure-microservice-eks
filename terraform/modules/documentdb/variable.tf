variable "subnet_group_name" {
  description = "Name for the DocumentDB subnet group"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the subnet group"
  type        = list(string)
}

variable "cluster_identifier" {
  description = "Identifier for the DocumentDB cluster"
  type        = string
}

variable "master_username" {
  description = "Master username for the DocumentDB cluster"
  type        = string
}

variable "master_password" {
  description = "Master password for the DocumentDB cluster"
  type        = string
  sensitive   = true
}

variable "backup_retention_period" {
  description = "Days to retain backups"
  type        = number
}

variable "preferred_backup_window" {
  description = "Preferred backup window time"
  type        = string
}

variable "instance_class" {
  description = "Instance type for DocumentDB instances"
  type        = string
}

variable "instance_count" {
  description = "Number of instances to launch in the cluster"
  type        = number
}

variable "storage_encrypted" {
  description = "Whether storage is encrypted"
  type        = bool
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "vpc_id" {
  description = "The ID of the VPC where db will be deployed."
  type        = string
}

variable "app-security-group" {
  description = "List of application securtiy group"
  type        = string
}