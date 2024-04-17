# Creating virtual private network
resource "aws_vpc" "virtual_network" {
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = var.enable_dns
  tags                 = var.vpc-tag
}

# Creating public subnet 01
resource "aws_subnet" "virtual_subnet_pub01" {
  vpc_id                  = aws_vpc.virtual_network.id
  cidr_block              = element(var.subnet_cidr, 0)
  availability_zone       = element(var.availability_zone, 0)
  map_public_ip_on_launch = true
  tags                    = var.pub_subnet_tag1
}

# Creating public subnet 02
resource "aws_subnet" "virtual_subnet_pub02" {
  vpc_id                  = aws_vpc.virtual_network.id
  cidr_block              = element(var.subnet_cidr, 1)
  availability_zone       = element(var.availability_zone, 1)
  map_public_ip_on_launch = true
  tags                    = var.pub_subnet_tag2
}

# Creating private subnet 01
resource "aws_subnet" "virtual_subnet_pri01" {
  vpc_id            = aws_vpc.virtual_network.id
  cidr_block        = element(var.subnet_cidr, 2)
  availability_zone = element(var.availability_zone, 0)
  tags              = var.pri_subnet_tag1
}

# Creating private subnet 02
resource "aws_subnet" "virtual_subnet_pri02" {
  vpc_id            = aws_vpc.virtual_network.id
  cidr_block        = element(var.subnet_cidr, 3)
  availability_zone = element(var.availability_zone, 1)
  tags              = var.pri_subnet_tag2
}

# Creating internet_gateway
resource "aws_internet_gateway" "virtual_igw" {
  vpc_id = aws_vpc.virtual_network.id
  tags   = var.igw_tag
}

# Public route table
resource "aws_route_table" "virtual_pub_rt" {
  vpc_id = aws_vpc.virtual_network.id
  route {
    cidr_block = var.rt_cidr_block
    gateway_id = aws_internet_gateway.virtual_igw.id
  }
  tags = var.pub_rt_tag
}

# Public route table association
resource "aws_route_table_association" "virtual_pub_rt_ass01" {
  route_table_id = aws_route_table.virtual_pub_rt.id
  subnet_id      = aws_subnet.virtual_subnet_pub01.id
}

# Public route table association
resource "aws_route_table_association" "virtual_pub_rt_ass02" {
  route_table_id = aws_route_table.virtual_pub_rt.id
  subnet_id      = aws_subnet.virtual_subnet_pub02.id
}

# Private route table
resource "aws_route_table" "virtual_pri_rt" {
  vpc_id = aws_vpc.virtual_network.id
  tags   = var.pri_rt_tag
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

# Private route table association
resource "aws_route_table_association" "virtual_pri_rt_ass01" {
  route_table_id = aws_route_table.virtual_pri_rt.id
  subnet_id      = aws_subnet.virtual_subnet_pri01.id
}

# Private route table association
resource "aws_route_table_association" "virtual_pri_rt_ass02" {
  route_table_id = aws_route_table.virtual_pri_rt.id
  subnet_id      = aws_subnet.virtual_subnet_pri02.id
}

#Create elastic ip address
resource "aws_eip" "Elastic_IPs" {
}

#create nat_gateway
resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = aws_subnet.virtual_subnet_pub01.id
  allocation_id = aws_eip.Elastic_IPs.id
  tags          = var.nat_gateway
}

#Create Network ACLs
resource "aws_network_acl" "network_access" {
  vpc_id = aws_vpc.virtual_network.id
  tags   = var.NACLs
}

#Create SSH_Inbound
resource "aws_network_acl_rule" "ssh_inbound" {
  network_acl_id = aws_network_acl.network_access.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

#Create HTTP_Inbound
resource "aws_network_acl_rule" "http_inbound" {
  network_acl_id = aws_network_acl.network_access.id
  rule_number    = 101
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

#Create HTTPS_Inbound
resource "aws_network_acl_rule" "https_inbound" {
  network_acl_id = aws_network_acl.network_access.id
  rule_number    = 102
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

#Create SSH_Outbound
resource "aws_network_acl_rule" "ssh_outbound" {
  network_acl_id = aws_network_acl.network_access.id
  rule_number    = 200
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

#Create HTTP_Outbound
resource "aws_network_acl_rule" "http_outbound" {
  network_acl_id = aws_network_acl.network_access.id
  rule_number    = 201
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

#Create HTTPS_Outbound
resource "aws_network_acl_rule" "https_outbound" {
  network_acl_id = aws_network_acl.network_access.id
  rule_number    = 202
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

#Create security groups
resource "aws_security_group" "virtual_sg" {
  name        = "virtual_sg1"
  description = "Traffic to internet http"
  vpc_id      = aws_vpc.virtual_network.id
  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.sg
}

# Create Interface VPC endpoint
resource "aws_vpc_endpoint" "s3_endpoint" {
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_id            = aws_vpc.virtual_network.id
  vpc_endpoint_type = "Gateway"
  tags              = var.endpoint
}

