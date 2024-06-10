# Define Route 53 zone and record

resource "aws_route53_zone" "my_hosted_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "records" {
  zone_id = aws_route53_zone.my_hosted_zone.zone_id
  name    = "example.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = ["3.229.76.66"]
}

