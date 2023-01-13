resource "aws_subnet" "internal_public_east_1a" {
  assign_ipv6_address_on_creation = false
  availability_zone               = "us-east-1a"
  cidr_block                      = var.internal_public_east_1a_cidr
  map_public_ip_on_launch         = false
  tags = {
    Name    = "internal-pub-east-1a"
    Managed = "Terraform"
    env     = "test"
  }
  vpc_id = aws_vpc.internal_test.id
}

output "subnet_public_east_1a_id" {
  value = aws_subnet.internal_public_east_1a.id
}

resource "aws_subnet" "internal_public_east_1b" {
  assign_ipv6_address_on_creation = false
  availability_zone               = "us-east-1b"
  cidr_block                      = var.internal_public_east_1b_cidr
  map_public_ip_on_launch         = false
  tags = {
    Name    = "internal-pub-east-1b"
    Managed = "Terraform"
    env     = "test"
  }
  vpc_id = aws_vpc.internal_test.id
}

output "subnet_internal_public_east_1b_id" {
  value = aws_subnet.internal_public_east_1b.id
}

resource "aws_route_table_association" "internal_pub_1a" {
  subnet_id      = aws_subnet.internal_public_east_1a.id
  route_table_id = aws_route_table.internal_pub.id
}

resource "aws_route_table_association" "internal_pub_1b" {
  subnet_id      = aws_subnet.internal_public_east_1b.id
  route_table_id = aws_route_table.internal_pub.id
}

resource "aws_route_table" "internal_pub" {
  propagating_vgws = []
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internal_test.id

  }
  tags = {
    Name    = "test_pub_rt"
    Managed = "Terraform"
    env     = "test"
  }
  tags_all = {
    "Name"                     = "test-pub-rt"
    "app"                      = "vpc"
    "env"                      = "test"
  }
  vpc_id = aws_vpc.internal_test.id


}


resource "aws_route" "internal_pub_igw" {
  route_table_id         = aws_route_table.internal_pub.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internal_test.id
  depends_on = [
    aws_route_table.internal_pub
  ]
}