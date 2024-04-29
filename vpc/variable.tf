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
    Name        = "virtual_network"
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
    Name        = "virtual_subnet_pub01",
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
    Name        = "virtual_subnet_pub02",
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
    Name        = "virtual_subnet_pri01"
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
    Name        = "virtual_subnet_pri02",
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
    Name        = "virtual_igw"
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
    Name        = "virtual_pub_rt"
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
    Name        = "virtual_pri_rt"
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
    Name        = "virtual_nat_gateway"
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
    Name        = "virtual_sg"
    Environment = "Dev"
  })
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
  }))
  default = [
    {
      description      = "Allow SSH traffic"
      from_port        = 22
      to_port          = 22
      protocol         = "TCP"
      cidr_blocks      = ["0.0.0.0/0"]
    },
    {
      description      = "Allow HTTPS traffic"
      from_port        = 443
      to_port          = 443
      protocol         = "TCP"
      cidr_blocks      = ["0.0.0.0/0"]
    },
    {
      description      = "Allow MySQL traffic"
      from_port        = 3306
      to_port          = 3306
      protocol         = "TCP"
      cidr_blocks      = ["0.0.0.0/0"]
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
    Name        = "virtual_private_endpoint"
    Environment = "Dev"
  })
}
