variable "create_policy" {
  description = "Whether to create the IAM policy"
  type        = bool
  default     = true
}

variable "name" {
  description = "The name of the policy"
  type        = string
  default     = "digidence"
}

variable "path" {
  description = "The path of the policy in IAM"
  type        = string
  default     = "/"
}

variable "description" {
  description = "The description of the policy"
  type        = string
  default     = "IAM Policy"
}

variable "policy_name" {
  description = "The name of the managed policy to attach"
  type        = string
  default     = "AdministratorAccess"
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "iam_role_assume" {
  description = "The name of the IAM role"
  type        = string
  default = "IAM_assume_role"
}


