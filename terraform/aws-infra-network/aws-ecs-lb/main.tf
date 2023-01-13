## ECS task execution role data
data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECS task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = var.ecs_task_execution_role
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  for_each   = toset(var.policy_list)
  policy_arn = "arn:aws:iam::aws:policy/${each.key}"
}
resource "aws_alb" "alb" {
  name                       = var.alb_name
  subnets                    = var.subnet_ids_lb
  security_groups            = [var.security_grp]
}

resource "aws_alb_target_group" "alb_targetgroup" {
  name        = var.alb_tg_name
  port        = var.app_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 4
    protocol            = "HTTP"
    matcher             = "200"
    path                = var.health_check_path
    interval            = 30
  }
}

#redirecting all incomming traffic from ALB to the target group
resource "aws_alb_listener" "app_listener" {
  load_balancer_arn = aws_alb.alb.id
  port              = var.app_port
  protocol          = "HTTP"
  #enable above 2 if you are using HTTPS listner and change protocal from HTTPS to HTTPS
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_targetgroup.arn
  }
}

resource "aws_ecs_cluster" "cluster_name" {
  name = var.ecs_cluster_name
}
locals {
  container_def = {
    app_image      = var.app_image,
    app_port       = var.app_port,
    fargate_cpu    = var.fargate_cpu,
    fargate_memory = var.fargate_memory,
    aws_region     = var.aws_region,
    app            = var.app,
    env            = var.env
  }
}
resource "aws_ecs_task_definition" "ecs_def" {
  family                   = join("-", [var.app, var.env])
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = templatefile(var.template_file, local.container_def)
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_ecs_service" "ecs_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.cluster_name.id
  task_definition = aws_ecs_task_definition.ecs_def.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [var.security_grp]
    subnets         = var.subnet_ids_ecs
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.alb_targetgroup.arn
    container_name   = join("-", [var.app, var.env])
    container_port   = var.container_port
  }
  depends_on = [aws_alb_listener.app_listener, aws_iam_role_policy_attachment.ecs_task_execution_role]
}