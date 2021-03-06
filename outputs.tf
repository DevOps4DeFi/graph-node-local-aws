output "access_url" {
  value = "https://${aws_route53_record.graphql.fqdn}"
  description = "The base url to hit to access the graph-node"
}

output "rds_access_endpoint" {
  value = try(module.rds[0].this_db_instance_endpoint, null)
  description = "The url of an external rds database used with this subgraph."
}
