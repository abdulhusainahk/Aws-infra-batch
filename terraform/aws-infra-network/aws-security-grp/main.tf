# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "alb-sg" {
  name        = var.alb_security_grp_name
  description = "controls access to the ALB"
  vpc_id      = var.vpc
  ingress {
    protocol    = "tcp"
    from_port   = var.appport
    to_port     = var.appport
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# this security group for ecs - Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_sg" {
  name        = var.ecs_security_grp_name
  description = "allow inbound access from the ALB only"
  vpc_id      = var.vpc
  ingress {
    protocol        = "tcp"
    from_port       = var.appport
    to_port         = var.appport
    security_groups = [aws_security_group.alb-sg.id]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}