resource "aws_subnet" "internal_private_east_1b" {
  assign_ipv6_address_on_creation = false
  availability_zone               = "us-east-1b"
  cidr_block                      = var.internal_private_east_1b_cidr
  map_public_ip_on_launch         = false
  tags = {
    Name    = "internal-private-east-1b"
    Managed = "Terraform"
    env     = "test"
  }
  vpc_id = aws_vpc.internal_test.id
}


resource "aws_route_table_association" "emsmart2_nonprod_private_1b" {
  subnet_id      = aws_subnet.internal_private_east_1b.id
  route_table_id = aws_route_table.internal_private_1b.id
}


resource "aws_route_table" "internal_private_1b" {
  propagating_vgws = []
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.internal_pub_1b.id
  }
  tags = {
    Name    = "internal_private_1b_rt"
    Managed = "Terraform"
    env     = "test"
  }
  tags_all = {
    "Managed"                  = "Terraform"
    "Name"                     = "internal-private-1b-rt"
    "app"                      = "vpc"
  }
  vpc_id = aws_vpc.internal_test.id
}


output "subnet_private_east_1b_id" {
  value = aws_subnet.internal_private_east_1b.id
}
