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

resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.code2d_org.zone_id
  name    = "code2d.org"
  type    = "A"
  ttl     = local.record_ttl
  records = ["76.76.21.21"]
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


resource "aws_route53_record" "dictionary" {
  zone_id = aws_route53_zone.code2d_org.zone_id
  name    = "dictionary.code2d.org"
  type    = "CNAME"
  ttl     = local.record_ttl
  records = ["cname.vercel-dns.com."]
}

resource "aws_route53_record" "vercel" {
  zone_id = aws_route53_zone.code2d_org.zone_id
  name    = "_vercel"
  type    = "TXT"
  ttl     = local.record_ttl
  records = [
    "vc-domain-verify=code2d.org,44345a92c0d3ff67651c",
    "vc-domain-verify=dictionary.code2d.org,0144bb9d863b3ed5148a",
  ]
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

resource "aws_route53_record" "argon_raviqqe_com" {
  zone_id = aws_route53_zone.raviqqe_com.zone_id
  name    = "argon.raviqqe.com"
  type    = "A"
  ttl     = local.record_ttl
  records = [aws_eip.argon.public_ip]
}

resource "aws_route53_record" "xenon_raviqqe_com" {
  zone_id = aws_route53_zone.raviqqe_com.zone_id
  name    = "xenon.raviqqe.com"
  type    = "A"
  ttl     = local.record_ttl
  records = [google_compute_address.xenon.address]
}

resource "aws_route53_zone" "ytoyama_com" {
  name = "ytoyama.com"
}
