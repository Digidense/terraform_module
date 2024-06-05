variable "role_name" {
  type        = string
  description = "Name of the IAM role for the EKS cluster"
  default     = "eks-policy-role"
}

variable "node_attachment_name" {
  type        = string
  description = "Name of the IAM policy attachment for the EKS node group"
  default     = "eks-node-attachments1"
}

variable "eks_cluster_attachment_name" {
  type        = string
  description = "Name of the IAM policy attachment for the EKS cluster"
  default     = "eks-policy-attachments1"
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

# vpc variables

variable "cidr" {
  description = "pass the cidr value of the vpc"
  type        = string
  default     = "192.168.0.0/24"
}

variable "enable_dns" {
  description = "Enable dns hostnames"
  type        = bool
  default     = true
}

variable "vpc-tag" {
  description = "The  name of vpc"
  type = object({
    Name        = string
    Environment = string
  })
  default = ({
    Name        = "VPC"
    Environment = "Dev"
  })
}

variable "subnet_cidr" {
  description = "Subnet cidr block address"
  type        = list(string)
  default     = ["192.168.0.0/26", "192.168.0.64/26", "192.168.0.128/26", "192.168.0.192/26"]
}

variable "availability_zone" {
  description = "Choose the availability zone"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "pub_subnet_tag1" {
  description = "The public  subnets 01"
  type = object({
    Name        = string
    Environment = string
  })
  default = ({
    Name        = "VPC_Subnet_pub1",
    Environment = "Dev"
  })
}

variable "pub_subnet_tag2" {
  description = "The name of subnets"
  type = object({
    Name        = string
    Environment = string
  })
  default = ({
    Name        = "VPC_Subnet_pub2",
    Environment = "Dev"
  })
}

variable "pri_subnet_tag1" {
  description = "The name of subnets"
  type = object({
    Name        = string
    Environment = string
  })
  default = ({
    Name        = "VPC_Subnet_pri1"
    Environment = "Dev"
  })
}

variable "pri_subnet_tag2" {
  description = "The name of subnets"
  type = object({
    Name        = string
    Environment = string
  })
  default = ({
    Name        = "VPC_Subnet_pri2",
    Environment = "Dev"
  })
}

variable "igw_tag" {
  description = "internet gateway tag"
  type = object({
    Name        = string
    Environment = string
  })
  default = ({
    Name        = "VPC_IGW"
    Environment = "Dev"
  })
}

variable "pub_rt_tag" {
  description = "Public route table tag"
  type = object({
    Name        = string
    Environment = string
  })
  default = ({
    Name        = "VPC_ROUTE_pub"
    Environment = "Dev"
  })
}

variable "rt_cidr_block" {
  description = "route table cider block"
  type        = string
  default     = "0.0.0.0/0"
}

variable "pri_rt_tag" {
  description = "Private route table tag"
  type = object({
    Name        = string
    Environment = string
  })
  default = ({
    Name        = "VPC_ROUTE_pri"
    Environment = "Dev"
  })
}

variable "nat_gateway" {
  description = "Create the nat gateway"
  type = object({
    Name        = string
    Environment = string
  })
  default = ({
    Name        = "VPC_NAT"
    Environment = "Dev"
  })
}

variable "sg" {
  description = "Create the security groups"
  type = object({
    Name        = string
    Environment = string
  })
  default = ({
    Name        = "VPC_SG"
    Environment = "Dev"
  })
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Allow SSH traffic"
      from_port   = 22
      to_port     = 22
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow HTTPS traffic"
      from_port   = 443
      to_port     = 443
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow MySQL traffic"
      from_port   = 3306
      to_port     = 3306
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow PostgreSQL traffic"
      from_port   = 5432
      to_port     = 5432
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "egress_rules" {
  description = "List of egress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "endpoint" {
  description = "Create the security groups"
  type = object({
    Name        = string
    Environment = string
  })
  default = ({
    Name        = "VPC_ENDPOINT"
    Environment = "Dev"
  })
}
