variable "aliases_name" {
  type        = string
  description = "this block is for aliases name declaration"
  default     = "alias/Kms_ecr_key"
}

variable "deletion_day" {
  type        = number
  description = "this block is for deletion_window_in_days declaration"
  default     = 7
}

variable "enable_key_rotation" {
  type        = bool
  description = "this block is for enable_key_rotation  declaration"
  default     = true
}

variable "policy_name" {
  type        = string
  description = "this block is for policy_name declaration"
  default     = "ecr-push-role"
}

variable "ecr-push-policy" {
  type        = string
  description = "this block is for  ecr-push-policy declaration"
  default     = "ecr-push-policy"
}

variable "ecr-name" {
  type        = string
  description = "this block is for  ecr-name declaration"
  default     = "digi-ecr"
}

variable "mutable" {
  type        = string
  description = "this block is for mutable declaration"
  default     = "MUTABLE"
}

variable "encryption_type" {
  type        = string
  description = "this block is for  encryption_type declaration"
  default     = "KMS"
}

