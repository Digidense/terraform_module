variable "region" {
  type        = string
  description = "this block is for region"
  default     = "us-east-1"
}

variable "max_retries" {
  type        = number
  description = "this block is for max_retries"
  default     = 10
}

variable "role_name" {
  type        = string
  description = "Name of the IAM role for the EKS cluster"
  default     = "eks-cluster-role"
}

variable "node_attachment_name" {
  type        = string
  description = "Name of the IAM policy attachment for the EKS node group"
  default     = "eks-cluster-node-attachment"
}

variable "eks_cluster_attachment_name" {
  type        = string
  description = "Name of the IAM policy attachment for the EKS cluster"
  default     = "eks-cluster-policy-attachment"
}

variable "eks_cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = "unique_cluster"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs in different availability zones (AZs)"
  default     = ["subnet-09aab3e001a66bb73", "subnet-0f0b451c7faef2e34"]
}

variable "addons_name" {
  type        = list(string)
  description = "List of names of addons to be installed on the EKS cluster"
  default     = ["vpc-cni", "kube-proxy", "eks-pod-identity-agent", "coredns"]
}

variable "addons_versions" {
  type        = list(string)
  description = "List of versions of addons to be installed on the EKS cluster"
  default     = ["1.29", "v1.16.0-eksbuild.1", "v1.29.0-eksbuild.1", "v1.2.0-eksbuild.1", "v1.11.1-eksbuild.4"] #first index is eks_cluster version
}

variable "node_group_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = "unique_cluster_Node_Group"
}


