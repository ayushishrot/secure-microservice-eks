variable "secret_name" {
  description = "Name of the secret"
  type        = string
}

variable "secret_description" {
  description = "Description of the secret"
  type        = string
  default     = ""
}

variable "secret_string" {
  description = "The secret value to store"
  type        = string
  sensitive   = true
}

variable "kms_key_id" {
  description = "KMS Key ID to encrypt the secret. If null, default AWS key is used."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to assign to the secret"
  type        = map(string)
  default     = {}
}

variable "create_secret" {
  description = "Whether to create or skip creating the secret"
  type        = bool
}
