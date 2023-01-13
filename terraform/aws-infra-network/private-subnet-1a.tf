resource "aws_subnet" "internal_private_east_1a" {
  assign_ipv6_address_on_creation = false
  availability_zone               = "us-east-1a"
  cidr_block                      = var.internal_private_east_1a_cidr
  map_public_ip_on_launch         = false
  tags = {
    Name    = "internal-private-east-1a"
    Managed = "Terraform"
    env     = "test"
  }
  vpc_id = aws_vpc.internal_test.id
}

output "internal_private_east_1a_id" {
  value = aws_subnet.internal_private_east_1a.id
}

resource "aws_route_table_association" "internal_private_1a" {
  subnet_id      = aws_subnet.internal_private_east_1a.id
  route_table_id = aws_route_table.internal_private_1a.id
}

resource "aws_route_table" "internal_private_1a" {
  propagating_vgws = []
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.internal_pub_1a.id
  }

  tags = {
    Name    = "internal_private_1a_rt"
    Managed = "Terraform"
    env     = "test"
  }
  tags_all = {
    "Managed"                  = "Terraform"
    "Name"                     = "interanal-private-1a-rt"
    "app"                      = "vpc"
    "env"                      = "test"
  }
  vpc_id = aws_vpc.internal_test.id
}