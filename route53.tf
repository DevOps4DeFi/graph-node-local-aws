
data "aws_route53_zone" "rootzone" {
  name = local.route53_root_fqdn
}
resource "aws_route53_record" "graphql" {
  name    = var.app_name
  type    = "A"
  zone_id = data.aws_route53_zone.rootzone.zone_id
  alias {
    evaluate_target_health = false
    name                   = data.aws_lb.graph_alb.dns_name
    zone_id                = data.aws_lb.graph_alb.zone_id
  }
}

resource "aws_route53_record" "graph-metrics" {
  name    = "${var.app_name}-metrics"
  type    = "A"
  zone_id = data.aws_route53_zone.rootzone.zone_id
  alias {
    evaluate_target_health = false
    name                   = data.aws_lb.index_alb.dns_name
    zone_id                = data.aws_lb.index_alb.zone_id
  }
}

resource "aws_route53_record" "graph-rpcadmin" {
  name = "${var.app_name}-rpcadmin"
  type = "A"
  zone_id = data.aws_route53_zone.rootzone.zone_id
  alias {
    evaluate_target_health = false
    name = data.aws_lb.index_alb.dns_name
    zone_id = data.aws_lb.index_alb.zone_id
  }
}


resource "aws_route53_record" "graph-health" {
  name = "${var.app_name}-health"
  type = "A"
  zone_id = data.aws_route53_zone.rootzone.zone_id
  alias {
    evaluate_target_health = false
    name = data.aws_lb.graph_alb.dns_name
    zone_id = data.aws_lb.graph_alb.zone_id
  }
}