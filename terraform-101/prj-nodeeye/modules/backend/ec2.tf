resource "aws_key_pair" "key" {
  key_name   = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}"
  public_key = lookup(var.common, "prod.public_key")
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [""] # Canonical
}

resource "aws_instance" "ec2_bastion" {
  ami                     = "ami-0f4a33e30d0555a25"
  instance_type           = "t3.micro"
  key_name                = aws_key_pair.key.key_name
  subnet_id               = aws_subnet.public_a.id

  vpc_security_group_ids = [
    aws_security_group.bastion.id,
  ]

  tags = {
    Name              = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-bastion"
  }
}
