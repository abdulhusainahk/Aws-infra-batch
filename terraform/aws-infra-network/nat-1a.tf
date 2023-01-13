resource "aws_nat_gateway" "internal_pub_1a" {
  allocation_id = aws_eip.internal_nat_1a.id
  subnet_id     = aws_subnet.internal_public_east_1a.id
}

resource "aws_eip" "internal_nat_1a" {
  vpc = true
  tags = {
    "Name" = "test-nat-1a"
  }
}