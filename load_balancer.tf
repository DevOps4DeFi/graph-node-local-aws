data "aws_lb" "graph_alb" {
  name = var.graph_lb_name
}
data "aws_lb" "index_alb" {
  name = var.index_lb_name
}

######
### Port 8000 GRAPHQL
######

resource "aws_lb_target_group" "graphql" {
  name_prefix     = "gn-gql"
  port     = "8000"
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  tags = {
    name = "${var.app_name}-graphql"
  }
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/"
    port                = 8000
  }
}
resource "aws_lb_listener_rule" "graphql" {
  listener_arn = var.graphql_lb_listener_arn
  action {
    target_group_arn = aws_lb_target_group.graphql.arn
    type = "forward"
  }
  condition {
    host_header {
      values = [
        aws_route53_record.graphql.fqdn]
    }
  }
}

resource "aws_autoscaling_attachment" "graphql" {
  alb_target_group_arn   = aws_lb_target_group.graphql.arn
  autoscaling_group_name = aws_autoscaling_group.graphnode.name
  depends_on = [aws_lb_listener_rule.graphql]
}
######
### Port 8020 ADMIN
######

resource "aws_lb_target_group" "graph-rpcadmin" {
  name_prefix     = "gn-rpc"
  port     = "8020"
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  tags = {
    Name = "${var.app_name}-rpcadmin"
  }
  health_check { 
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/"
    port                = 8020
  }
}



resource "aws_lb_listener_rule" "graph-rpcadmin" {
  listener_arn = var.admin_lb_listener_arn
  action {
    target_group_arn = aws_lb_target_group.graph-rpcadmin.arn
    type = "forward"
  }
  condition {
    host_header {
      values = [
        aws_route53_record.graph-rpcadmin.fqdn]
    }
  }
}

resource "aws_autoscaling_attachment" "graph-rpcadmin" {
  alb_target_group_arn   = aws_lb_target_group.graph-rpcadmin.arn
  autoscaling_group_name = aws_autoscaling_group.graphnode.name
  depends_on = [aws_lb_listener_rule.graph-rpcadmin]
}
######
###  Port 8030 - Health
######
resource "aws_lb_target_group" "graph-health" {
  name_prefix     = "gn-hlt"
  port     = "8030"
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  tags = {
    Name = "${var.app_name}-health"
  }
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/"
    port                = 8030
  }
}
resource "aws_autoscaling_attachment" "graph-health" {
  alb_target_group_arn   = aws_lb_target_group.graph-health.arn
  autoscaling_group_name = aws_autoscaling_group.graphnode.name
  depends_on = [aws_lb_listener_rule.graph-health]
}
resource "aws_lb_listener_rule" "graph-health" {
  listener_arn = var.graphql_lb_listener_arn
  action {
    target_group_arn = aws_lb_target_group.graph-health.arn
    type = "forward"
  }
  condition {
    host_header {
      values = [
        aws_route53_record.graph-health.fqdn]
    }
  }
}

######
### Port 8040 PROM metrics
######

resource "aws_lb_target_group" "graph-metrics" {
  name_prefix     = "gn-mtx"
  port     = "8040"
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  tags = {
    Name = "${var.app_name}-metrics"
  }
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/"
    port                = 8040
  }
}



resource "aws_lb_listener_rule" "graph-metrics" {
  listener_arn = var.admin_lb_listener_arn
  action {
    target_group_arn = aws_lb_target_group.graph-metrics.arn
    type = "forward"
  }
  condition {
    host_header {
      values = [
        aws_route53_record.graph-metrics.fqdn]
    }
  }
}

resource "aws_autoscaling_attachment" "graph-metrics" {
  alb_target_group_arn   = aws_lb_target_group.graph-metrics.arn
  autoscaling_group_name = aws_autoscaling_group.graphnode.name
  depends_on = [aws_lb_listener_rule.graph-metrics]
}



