resource "aws_nat_gateway" "ngw_a" {
  allocation_id = aws_eip.eip_for_nat_a.id
  subnet_id     = aws_subnet.public_a.id
  tags = {
    Name = "nat gateway a"
  }
}

# resource "aws_nat_gateway" "ngw_c" {
#   allocation_id = aws_eip.eip_for_nat_c.id
#   subnet_id     = aws_subnet.public_c.id
#   tags = {
#     Name = "nat gateway c"
#   }
# }

resource "aws_eip" "eip_for_nat_a" {
  domain = "vpc"
  tags = {
    Name = "for ng a"
  }
}

# resource "aws_eip" "eip_for_nat_c" {
#   domain = "vpc"
#   tags = {
#     Name = "for ng c"
#   }
# }
