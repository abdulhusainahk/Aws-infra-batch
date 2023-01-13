output "target_grp_arn" {
  value = aws_alb_target_group.alb_targetgroup.arn
}
output "execution_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}
output "dns_name" {
  value = aws_alb.alb.dns_name
}