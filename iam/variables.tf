variable "name" {
  description = "This block is for name creations"
  type        = list(string)
  default     = ["sns_policy", "sns_role_attachment", "sns_role"]
}

