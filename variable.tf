variable "aws_region" {
  default = "eu-west-1"
}

variable "cluster_name" {
  default = "my-cluster"
}

variable "node_group_name" {
  default = "my-node-group"
}

variable "subnet_ids" {
  type        = list(string)
  default     = ["subnet-0a28caeeecd4d0aae", "subnet-0984c8c8344521c38"]
}

variable "security_group_ids" {
  type        = list(string)
  default     = ["sg-0d17542a5d70e6ca0"]
}

variable "desired_size" {
  default = 2
}

variable "max_size" {
  default = 2
}

variable "min_size" {
  default = 1
}
