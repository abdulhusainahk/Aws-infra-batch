resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "batchdb"
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  db_subnet_group_name = aws_db_subnet_group.default.name
  username             = var.user
  password             = var.passwd 
  port                 = 5431
  skip_final_snapshot  = true
}
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}