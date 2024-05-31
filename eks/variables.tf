variable "role_name" {
  type        = string
  description = "Name of the IAM role for the EKS cluster"
  default     = "eks-policy-role1sWs"
}

variable "node_attachment_name" {
  type        = string
  description = "Name of the IAM policy attachment for the EKS node group"
  default     = "eks-node-attachmentsW1"
}

variable "eks_cluster_attachment_name" {
  type        = string
  description = "Name of the IAM policy attachment for the EKS cluster"
  default     = "eks-policy-attachmentsW1"
}

variable "eks_cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = "COOL_Cluster_EKS"
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
      version = "v1.18.1-eksbuild.3"
    },
    {
      name    = "kube-proxy"
      version = "v1.29.3-eksbuild.2"
    },
    {
      name    = "coredns"
      version = "v1.11.1-eksbuild.9"
    }
  ]
}

variable "node_group_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = "Node_GroupW1"
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

variable "region" {
  type        = string
  description = "region of the EKS cluster node creation"
  default     = "us-east-1"
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
