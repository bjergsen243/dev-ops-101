resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${lower(lookup(var.common, "${terraform.workspace}.profile"))}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

# Subnet
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.subnets[0]
  availability_zone       = "${lookup(var.common, "${terraform.workspace}.region", var.common["default.region"])}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public a"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.subnets[1]
  availability_zone       = "${lookup(var.common, "${terraform.workspace}.region", var.common["default.region"])}c"
  map_public_ip_on_launch = true
  tags = {
    Name = "public c"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.subnets[2]
  availability_zone       = "${lookup(var.common, "${terraform.workspace}.region", var.common["default.region"])}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "private a"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.subnets[3]
  availability_zone       = "${lookup(var.common, "${terraform.workspace}.region", var.common["default.region"])}c"
  map_public_ip_on_launch = true
  tags = {
    Name = "private c"
  }
}

# Assign an elastic IP to the network interface created before
resource "aws_eip" "eip_igw" {
  domain       = "vpc"
  instance = aws_instance.ec2_bastion.id
  depends_on = [ aws_internet_gateway.igw ]
}

#VPC endpoint
resource "aws_vpc_endpoint" "logs" {
  tags = {
    Name = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-vpce-logs"
  }
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${lookup(var.common, "${terraform.workspace}.region", var.common["default.region"])}.logs"
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.vpce.id
  ]

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_c.id
  ]
}

resource "aws_vpc_endpoint" "s3" {
  tags = {
    Name = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-vpce-s3"
  }
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${lookup(var.common, "${terraform.workspace}.region", var.common["default.region"])}.s3"
  vpc_endpoint_type = "Gateway"
}

resource "aws_vpc_endpoint_route_table_association" "private_2a" {
  route_table_id  = aws_route_table.private_a.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

# ACL
resource "aws_network_acl" "acl" {
  vpc_id = aws_vpc.vpc.id
  subnet_ids = [
    aws_subnet.public_a.id,
    aws_subnet.public_c.id,
    aws_subnet.private_a.id,
    aws_subnet.private_c.id
  ]

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "ACL private"
  }
}
