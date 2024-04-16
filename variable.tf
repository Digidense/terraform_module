variable "aliases_name" {
  type = string
  description = "this block is for aliases name decleration"
  default = "alias/Kms_ecr_key"
}
variable "deleation_day" {
  type = string
  description = "this block is for deletion_window_in_days decleration"
  default = 7
}

variable "enable_key_rotation" {
  type = bool
  description = "this block is for enable_key_rotation  decleration"
  default = true
}

variable "policy_name" {
  type = string
  description = "this block is for policy_name decleration"
  default = "ecr-push-role"
}

variable  "ecr-push-policy" {
  type = string
  description = "this block is for  ecr-push-policy decleration"
  default =  "ecr-push-policy"
}

variable  "ecr-name" {
  type = string
  description = "this block is for  ecr-name decleration"
  default =  "my-ecr"
}

variable  "mutable" {
  type = string
  description = "this block is for mutable decleration"
  default =  "MUTABLE"
}

variable  "encryption_type" {
  type = string
  description = "this block is for  encryption_type decleration"
  default =  "KMS"
}