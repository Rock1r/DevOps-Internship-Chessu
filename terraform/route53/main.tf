resource "aws_route53_zone" "chessu" {
  force_destroy = "false"
  name          = var.domain
}
