resource "aws_route53_zone" "my_hosted_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "alias_record" {
  zone_id = aws_route53_zone.my_hosted_zone.zone_id
  name    = "example.${var.domain_name}"
  type    = "A"
  alias {
    name                   = "a12670d490a7c4f8da6c79c340d4216c-773186114.us-east-1.elb.amazonaws.com"
    zone_id                = "Z35SXDOTRQ7X7K" 
    evaluate_target_health = true
  }
}
