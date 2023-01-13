variable "region" {
  default = "us-east-1"
}
variable "test_cidr" {
  default = "172.28.0.0/16"
}


variable "internal_public_east_1a_cidr" {
  default = "172.28.0.0/20"
}

variable "internal_public_east_1b_cidr" {
  default = "172.28.16.0/20"
}

variable "internal_private_east_1a_cidr" {
  default = "172.28.32.0/20"
}

variable "internal_private_east_1b_cidr" {
  default = "172.28.48.0/20"
}
 variable "AWS_SECRET_ACCESS_KEY" {
   
 }
 variable "AWS_ACCESS_KEY_ID" {
   
 }
 variable "bucket" {
   default = "testinternalbucketabdul"
 }
 variable "log_group_name" {
   default="batchloggroup"
 }
 variable "log_stream_name" {
   default = "ecsteststream"
 }
 variable "app_port" {
   default=80
 }
 variable "alb_security_grp_name" {
   default="test-lb-security-grp"
 }
 variable "ecs_security_grp_name" {
   default="test-ecs-security-grp"
 }
 variable "app_image" {
   default = "918557237823.dkr.ecr.us-east-1.amazonaws.com/batchimage:latest"
 }
 variable "fargate_cpu" {
   default = 512
 }
 variable "fargate_memory" {
   default = 1024
 }
 variable "app_count" {
   default = 1
 }
 variable "container_port" {
   default = 80
 }
 variable "ecs_task_execution_role" {
   default="internal-ecs-test-task-def"
 }
 variable "health_check_path" {
   default="/Health"
 }
 variable "alb_name" {
   default = "test-internal-alb"
 }
 variable "alb_tg_name" {
   default = "test-internal-tg"
 }
 variable "ecs_cluster_name" {
   default = "ecs-test-cluster"
 }
 variable "ecs_service_name" {
   default = "ecs-test-service"
 }
 variable "app" {
   default = "fargate-app"
 }
 variable "env" {
   default = "test"
 }
 variable "policy_list" {
   default = ["service-role/AmazonECSTaskExecutionRolePolicy", "AmazonS3FullAccess", "CloudWatchFullAccess"]
 }
 variable "postgresuser" {
   
 }
 variable "postgress_passwd" {
   
 }