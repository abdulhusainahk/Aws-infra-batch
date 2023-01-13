data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}


locals {
  aws_caller_id = data.aws_caller_identity.current.account_id
}
module "s3" {
  source = "./aws-s3"
  bucket      = var.bucket
}
module "aws-cloudwatch" {
  source                   = "./aws-cloudwatch"
  log_grp_name    = var.log_group_name
  log_stream_name = var.log_stream_name
}
module "aws-ecs-security-group" {
  source                = "./aws-security-grp"
  vpc                   = aws_vpc.internal_test.id
  appport               = var.app_port
  alb_security_grp_name = var.alb_security_grp_name
  ecs_security_grp_name = var.ecs_security_grp_name
}
module "aws-ecs-test" {
  source                  = "./aws-ecs-lb"
  app_image               = var.app_image
  app_port                = var.app_port
  fargate_cpu             = var.fargate_cpu
  fargate_memory          = var.fargate_memory
  aws_region              = var.region
  subnet_ids_ecs          = [aws_subnet.internal_private_east_1a.id, aws_subnet.internal_private_east_1b.id]
  subnet_ids_lb           = [aws_subnet.internal_public_east_1a.id, aws_subnet.internal_public_east_1b.id]
  app_count               = var.app_count
  container_port          = var.container_port
  security_grp            = module.aws-ecs-security-group.security_group_id
  vpc_id                  = aws_vpc.internal_test.id
  ecs_task_execution_role = var.ecs_task_execution_role
  template_file           = "./aws-ecs-lb/image.json"
  health_check_path       = var.health_check_path
  alb_name                = var.alb_name
  alb_tg_name             = var.alb_tg_name
  ecs_cluster_name        = var.ecs_cluster_name
  ecs_service_name        = var.ecs_service_name
  app                     = var.app
  env                     = var.env
  log_grp_name            = var.log_group_name
  policy_list             = var.policy_list
}
module "aws-rds" {
  source= "./aws-rds"
  subnet_ids           = [aws_subnet.internal_public_east_1a.id,aws_subnet.internal_public_east_1b.id]
  user                = var.postgresuser
  passwd              = var.postgress_passwd
}