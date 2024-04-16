variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "digidensebucket2024"
}

variable "lifecycle_prefix" {
  description = "The prefix for the lifecycle rule"
  type        = string
  default     = "logs/"
}

variable "lifecycle_expiration_days" {
  description = "The number of days after which objects with the lifecycle prefix will expire"
  type        = number
  default     = 90
}


variable "kms_key_description" {
  description = "The description of the KMS key"
  type        = string
  default     = "KMS key for S3 encryption"
}

variable "kms_key_deletion_window_days" {
  description = "The deletion window in days for the KMS key"
  type        = number
  default     = 30
}


