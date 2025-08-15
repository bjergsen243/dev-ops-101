resource "aws_key_pair" "key" {
  key_name   = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}"
  public_key = lookup(var.common, "prod.public_key")
}

resource "aws_instance" "ec2_bastion" {
  ami                     = "ami-047126e50991d067b"
  instance_type           = "t2.small"
  key_name                = aws_key_pair.key.key_name
  subnet_id               = aws_subnet.public_a.id

  vpc_security_group_ids = [
    aws_security_group.bastion.id,
  ]

  tags = {
    Name              = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-bastion"
  }
}
