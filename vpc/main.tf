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
#Create security groups
resource "aws_security_group" "virtual_sg" {
  name        = "virtual_sg"
  description = "Security group for virtual network"
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description      = ingress.value["description"]
      from_port        = ingress.value["from_port"]
      to_port          = ingress.value["to_port"]
      protocol         = ingress.value["protocol"]
      cidr_blocks      = ingress.value["cidr_blocks"]
    }
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.sg
}
# Create Interface VPC private endpoint
resource "aws_vpc_endpoint" "s3_endpoint" {
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_id            = aws_vpc.virtual_network.id
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.virtual_pri_rt.id]
  tags              = var.endpoint
}

