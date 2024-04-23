provider "aws" {
  region      = var.region
  max_retries = var.max_retries
}

# creating locals for policy reference
locals {
  ecr_readonly_policy_arn    = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  eks_cni_policy_arn         = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  eks_worker_node_policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  amazoneksclusterpolicy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Creating eks role for eks and ec2 service
resource "aws_iam_role" "eks_role" {
  name = var.role_name
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "eks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# creating the policy attachment for eks cluster
resource "aws_iam_policy_attachment" "eks_node_policy_attachments" {
  count      = 3
  name       = "var.node_attachment_name-${count.index}"
  roles      = [aws_iam_role.eks_role.name]
  policy_arn = element([local.ecr_readonly_policy_arn, local.eks_cni_policy_arn, local.eks_worker_node_policy_arn, local.amazoneksclusterpolicy_arn], count.index)
}

# Attach the AmazonEKSClusterPolicy to the eks_role
resource "aws_iam_policy_attachment" "eks_cluster_policy_attachment" {
  name       = var.eks_cluster_attachment_name
  roles      = [aws_iam_role.eks_role.name]
  policy_arn = local.amazoneksclusterpolicy_arn
}

# Creating the eks cluster
resource "aws_eks_cluster" "my_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_role.arn # Corrected the reference to match the role resource
  version  = var.addons_versions[0]

  vpc_config {
    subnet_ids = var.subnet_ids # Using the subnet_ids variable
  }
}

# Creating the cni addons for eks cluster
resource "aws_eks_addon" "cni" {
  cluster_name  = aws_eks_cluster.my_cluster.name
  addon_name    = var.addons_name[0]
  addon_version = var.addons_versions[1]
}

# Creating the kube_proxy addons for eks cluster
resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = aws_eks_cluster.my_cluster.name
  addon_name    = var.addons_name[1]
  addon_version = var.addons_versions[2]
}

## Creating the eks_pod_identity_agent addons for eks cluster
#resource "aws_eks_addon" "eks_pod_identity_agent" {
#  cluster_name  = aws_eks_cluster.my_cluster.name
#  addon_name    = var.addons_name[2]
#  addon_version = var.addons_versions[3]
#}

# Creating the coredns addons for eks cluster
resource "aws_eks_addon" "coredns" {
  cluster_name  = aws_eks_cluster.my_cluster.name
  addon_name    = var.addons_name[3]
  addon_version = var.addons_versions[4]
}

# Creating the node group
resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_role.arn
  subnet_ids      = var.subnet_ids
  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.mix_size
  }
  depends_on = [
    aws_eks_cluster.my_cluster,
  ]
}

# Creating role attachment for node group
resource "aws_iam_role_policy_attachment" "eks_additional_policies" {
  count      = length(local.additional_policies)
  role       = aws_iam_role.eks_role.name
  policy_arn = local.additional_policies[count.index]
}

locals {
  additional_policies = [
    local.ecr_readonly_policy_arn,
    local.eks_cni_policy_arn,
    local.eks_worker_node_policy_arn,
  ]
}


