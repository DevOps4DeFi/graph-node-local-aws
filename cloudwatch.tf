resource "aws_cloudwatch_log_group" "graphnode" {
  name = var.app_name
  tags = local.tags
}