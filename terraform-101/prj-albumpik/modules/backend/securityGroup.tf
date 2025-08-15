# VPC Endpoint
resource "aws_security_group" "vpce" {
  name        = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-vpce-sg"
  vpc_id      = aws_vpc.vpc.id
  description = "VPC endpoint security group"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "container sg"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "VPC_Endpoint_sg"
  }
}

# RDS Cluster
resource "aws_security_group" "rds" {
  name        = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-rds-sg"
  vpc_id      = aws_vpc.vpc.id
  description = "Aurora for PostgreSQL security group"

  ingress {
    description = "Port for ECS"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS_sg"
  }
}

#Bastion
resource "aws_security_group" "bastion" {
  name        = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-bastion-sg"
  vpc_id      = aws_vpc.vpc.id
  description = "Bastion security group"

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "swagger"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  

  tags = {
    Name = "Bastion_sg"
  }
}
