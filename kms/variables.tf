variable "description" {
  type        = string
  description = "The description for the KMS key"
}

variable "deletion_window_in_days" {
  type        = number
  description = "The deletion window in days"
}

variable "enable_key_rotation" {
  type        = bool
  description = "Enable key rotation"
}

variable "aliases_name" {
  type        = string
  description = "this is for kms key name creation"
}