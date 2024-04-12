variable "name" {
  description = "This block is for name creations"
  type        = list(string)
  default     = ["iam_policy", "iam_role_attachment", "iam_role"]
}

