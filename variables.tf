variable "role_name" {
  type        = string
  description = "Name of the IAM role for the EKS cluster"
  default     = "eks-policy-role"
}

variable "node_attachment_name" {
  type        = string
  description = "Name of the IAM policy attachment for the EKS node group"
  default     = "eks-node-attachments"
}

variable "eks_cluster_attachment_name" {
  type        = string
  description = "Name of the IAM policy attachment for the EKS cluster"
  default     = "eks-policy-attachments"
}

variable "eks_cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = "Flash_Cluster"
}


variable "addons_versions" {
  type = list(object({
    name    = string
    version = string
  }))
  description = "List of versions of addons to be installed on the EKS cluster"
  default = [
    {
      name    = "vpc-cni"
      version = "v1.16.0-eksbuild.1"
    },
    {
      name    = "kube-proxy"
      version = "v1.29.0-eksbuild.1"
    },
    {
      name    = "coredns"
      version = "v1.11.1-eksbuild.4"
    }
  ]
}

variable "node_group_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = "Node_Group"
}

variable "cluster_version" {
  type        = string
  description = "Eks cluster version"
  default     = "1.29"
}

variable "desired_size" {
  type        = number
  description = "desired_size EKS cluster node creation"
  default     = 2
}

variable "max_size" {
  type        = number
  description = "max_size EKS cluster node creation"
  default     = 2
}

variable "mix_size" {
  type        = number
  description = "mix_size EKS cluster node creation"
  default     = 1
}
