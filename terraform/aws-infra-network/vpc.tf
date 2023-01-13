resource "aws_vpc" "internal_test" {
  assign_generated_ipv6_cidr_block = false
  cidr_block                       = var.test_cidr
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = "default"
  tags = {
    Name    = "Credit Saison India Test VPC"
    Managed = "Terraform"
    env     = "test"
  }
}

output "interanl_test_vpc_id" {
  value = aws_vpc.internal_test.id
}

output "interanl_test_vpc_cidr" {
  value = aws_vpc.internal_test.cidr_block
}


resource "aws_main_route_table_association" "route_main" {
  vpc_id         = aws_vpc.internal_test.id
  route_table_id = aws_route_table.route_main.id
}

resource "aws_route_table" "route_main" {
  tags = {
    Name    = "Main-RT"
    Managed = "Terraform"
    env     = "test"
  }
  tags_all = {
  }
  vpc_id = aws_vpc.internal_test.id
}



resource "aws_internet_gateway" "internal_test" {
  tags = {
    Name    = "test-IGW"
    Managed = "Terraform"
    env     = "test"
  }
  vpc_id = aws_vpc.internal_test.id
}