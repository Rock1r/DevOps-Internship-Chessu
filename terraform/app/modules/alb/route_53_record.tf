resource "aws_route53_record" "chessu" {
  zone_id = var.hosted_zone_id 
  name    = "chessu.pp.ua"
  type    = "A"
  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }
}