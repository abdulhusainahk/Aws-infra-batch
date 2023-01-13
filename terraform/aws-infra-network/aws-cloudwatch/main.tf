# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "log_group" {
  name              = var.log_grp_name
  retention_in_days = 30
  tags = {
    Name = "log-group"
  }
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = var.log_stream_name
  log_group_name = aws_cloudwatch_log_group.log_group.name
}
