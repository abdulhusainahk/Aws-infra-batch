resource "aws_nat_gateway" "internal_pub_1b" {
  allocation_id = aws_eip.internal_nat_1b.id
  subnet_id     = aws_subnet.internal_public_east_1b.id
}

resource "aws_eip" "internal_nat_1b" {
  vpc = true
  tags = {
    "Name" = "test-nat-1b"
  }
}