output "test_cidr" {
  value = var.test_cidr
}

output "internal_public_east_1a_cidr" {
  value = var.internal_public_east_1a_cidr
}

output "internal_public_east_1b_cidr" {
  value = var.internal_public_east_1b_cidr
}

output "internal_private_east_1a_cidr" {
  value = var.internal_private_east_1a_cidr
}

output "internal_private_east_1b_cidr" {
  value = var.internal_private_east_1b_cidr
}


output "internal_nat_gw_1aid" {
  value = aws_nat_gateway.internal_pub_1a.id
}

output "internal_nat_gw_1bid" {
  value = aws_nat_gateway.internal_pub_1b.id
}