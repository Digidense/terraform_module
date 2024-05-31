locals {
  ecr_readonly_policy_arn    = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  eks_cni_policy_arn         = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  eks_worker_node_policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  amazoneksclusterpolicy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  cloudwatch_full_access_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  additional_policies = [
    local.ecr_readonly_policy_arn,
    local.eks_cni_policy_arn,
    local.eks_worker_node_policy_arn,
    local.cloudwatch_full_access_arn,
  ]
}

# Creating EKS role for EKS and EC2 service
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

# Creating policy attachment for EKS cluster
resource "aws_iam_policy_attachment" "eks_node_policy_attachments" {
  count      = 4
  name       = "${var.node_attachment_name}-${count.index}"
  roles      = [aws_iam_role.eks_role.name]
  policy_arn = element(local.additional_policies, count.index)
}

# Attach the AmazonEKSClusterPolicy to the EKS role
resource "aws_iam_policy_attachment" "eks_cluster_policy_attachment" {
  name       = var.eks_cluster_attachment_name
  roles      = [aws_iam_role.eks_role.name]
  policy_arn = local.amazoneksclusterpolicy_arn
}

# VPC module referring to create EKS cluster
module "vpc_module" {
  source = "git::https://github.com/Digidense/terraform_module.git//vpc?ref=feature/DD-42-VPC_module"
}

# Creating the EKS cluster
resource "aws_eks_cluster" "my_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_role.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids = [
      module.vpc_module.subnet_pri01,
      module.vpc_module.subnet_pri02
    ]
    security_group_ids     = [module.vpc_module.security_group_id]
    endpoint_public_access = true
  }
  timeouts {
    create = "30m"
  }
}

# Creating the CNI addon for the EKS cluster
resource "aws_eks_addon" "cni" {
  cluster_name  = aws_eks_cluster.my_cluster.name
  addon_name    = var.addons_versions[0].name
  addon_version = var.addons_versions[0].version
}

# Creating the kube-proxy addon for the EKS cluster
resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = aws_eks_cluster.my_cluster.name
  addon_name    = var.addons_versions[1].name
  addon_version = var.addons_versions[1].version
}

# Creating the CoreDNS addon for the EKS cluster
resource "aws_eks_addon" "coredns" {
  cluster_name  = aws_eks_cluster.my_cluster.name
  addon_name    = var.addons_versions[2].name
  addon_version = var.addons_versions[2].version
}

# Creating the node group
resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_role.arn
  subnet_ids = [
    module.vpc_module.subnet_pri01,
    module.vpc_module.subnet_pri02
  ]
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

# Fetch the OIDC provider thumbprint dynamically
data "tls_certificate" "eks_oidc" {
  url = "https://oidc.eks.${var.region}.amazonaws.com/id/${aws_eks_cluster.my_cluster.id}"
}

# Step 1: Create an IAM OIDC Provider
resource "aws_iam_openid_connect_provider" "oidc_provider" {
  url             = "https://oidc.eks.${var.region}.amazonaws.com/id/${aws_eks_cluster.my_cluster.id}"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint]
}

# Step 2: Create IAM Role and Policy for Service Accounts
resource "aws_iam_role" "eks_irsa_role" {
  name = "eks-irsa-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : aws_iam_openid_connect_provider.oidc_provider.arn
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${replace(aws_iam_openid_connect_provider.oidc_provider.url, "https://", "")}:sub" : "system:serviceaccount:default:example"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "eks_irsa_policy" {
  name        = "eks-irsa-policy"
  description = "Policy for EKS IRSA"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_irsa_policy_attachment" {
  role       = aws_iam_role.eks_irsa_role.name
  policy_arn = aws_iam_policy.eks_irsa_policy.arn
}

# Step 3: Annotate Kubernetes Service Account
resource "kubernetes_service_account" "example" {
  metadata {
    name      = "example"
    namespace = "default"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.eks_irsa_role.arn
    }
  }
}
