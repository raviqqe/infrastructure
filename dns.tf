locals {
  record_ttl = 300

  firebase_records = ["151.101.1.195", "151.101.65.195"]

  github_io = {
    domain = "github.io"
    records = [
      "185.199.108.153",
      "185.199.109.153",
      "185.199.110.153",
      "185.199.111.153"
    ]
  }

  cloe_github_domain = join(".", ["cloe-lang", local.github_io.domain])
  pen_github_domain  = join(".", ["pen-lang", local.github_io.domain])
}

resource "aws_route53_zone" "cloe_org" {
  name = "cloe-lang.org"
}

resource "aws_route53_record" "cloe_org" {
  zone_id = aws_route53_zone.cloe_org.zone_id
  name    = "cloe-lang.org"
  type    = "A"
  ttl     = local.record_ttl
  records = local.github_io.records
}

resource "aws_route53_record" "www_cloe_org" {
  zone_id = aws_route53_zone.cloe_org.zone_id
  name    = "www.cloe-lang.org"
  type    = "CNAME"
  ttl     = local.record_ttl
  records = [local.cloe_github_domain]
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
  ttl     = local.record_ttl
  records = local.firebase_records
}

resource "aws_route53_record" "notes" {
  zone_id = aws_route53_zone.code2d_org.zone_id
  name    = "notes.code2d.org"
  type    = "A"
  ttl     = local.record_ttl
  records = local.firebase_records
}

resource "aws_route53_record" "pomodoro" {
  zone_id = aws_route53_zone.code2d_org.zone_id
  name    = "pomodoro.code2d.org"
  type    = "A"
  ttl     = local.record_ttl
  records = local.firebase_records
}

resource "aws_route53_zone" "ein_com" {
  name = "ein-lang.com"
}

resource "aws_route53_zone" "ein_org" {
  name = "ein-lang.org"
}

resource "aws_route53_record" "ein_org" {
  zone_id = aws_route53_zone.ein_org.zone_id
  name    = "ein-lang.org"
  type    = "A"
  ttl     = local.record_ttl
  records = local.github_io.records
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

resource "aws_route53_record" "pen_org" {
  zone_id = aws_route53_zone.pen_org.zone_id
  name    = "pen-lang.org"
  type    = "A"
  ttl     = local.record_ttl
  records = local.github_io.records
}

resource "aws_route53_record" "doc_pen_org" {
  zone_id = aws_route53_zone.pen_org.zone_id
  name    = "doc.pen-lang.org"
  type    = "CNAME"
  ttl     = local.record_ttl
  records = [local.pen_github_domain]
}

resource "aws_route53_record" "www_pen_org" {
  zone_id = aws_route53_zone.pen_org.zone_id
  name    = "www.pen-lang.org"
  type    = "CNAME"
  ttl     = local.record_ttl
  records = [local.pen_github_domain]
}

resource "aws_route53_zone" "raviqqe_com" {
  name = "raviqqe.com"
}

resource "aws_route53_zone" "ytoyama_com" {
  name = "ytoyama.com"
}
