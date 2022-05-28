variable "firebase_records" {
  default = ["151.101.1.195", "151.101.65.195"]
}

variable "default_record_ttl" {
  default = 300
}

variable "record_ttl" {
  default = "300"
}

resource "aws_route53_zone" "cloe_org" {
  name = "cloe-lang.org"
}

resource "aws_route53_zone" "code2d_net" {
  name = "code2d.net"
}

resource "aws_route53_zone" "code2d_org" {
  name = "code2d.org"
}

resource "aws_route53_record" "tasks" {
  zone_id = aws_route53_zone.code2d_org.zone_id
  name    = "tasks.code2d.org"
  type    = "A"
  ttl     = var.default_record_ttl
  records = [aws_eip.lb.public_ip]
}

resource "aws_route53_record" "notes" {
  zone_id = aws_route53_zone.code2d_org.zone_id
  name    = "notes.code2d.org"
  type    = "A"
  ttl     = var.default_record_ttl
  records = [aws_eip.lb.public_ip]
}

resource "aws_route53_record" "pomodoro" {
  zone_id = aws_route53_zone.code2d_org.zone_id
  name    = "pomodoro.code2d.org"
  type    = "A"
  ttl     = var.default_record_ttl
  records = [aws_eip.lb.public_ip]
}

resource "aws_route53_zone" "ein_com" {
  name = "ein-lang.com"
}

resource "aws_route53_zone" "ein_org" {
  name = "ein-lang.org"
}

resource "aws_route53_zone" "flame_com" {
  name = "flame-lang.com"
}

resource "aws_route53_zone" "flame_org" {
  name = "flame-lang.org"
}

resource "aws_route53_zone" "pen_com" {
  name = "pen-lang.com"
}

resource "aws_route53_zone" "pen_org" {
  name = "pen-lang.org"
}

resource "aws_route53_zone" "raviqqe_com" {
  name = "raviqqe.com"
}

resource "aws_route53_zone" "ytoyama_com" {
  name = "ytoyama.com"
}
