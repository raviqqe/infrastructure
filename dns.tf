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

resource "aws_route53_zone" "ytoyama_com" {
  name = "ytoyama.com"
}

locals {
  zones = {
    cloe_org    = aws_route53_zone.cloe_org.id
    code2d_net  = aws_route53_zone.code2d_net.id
    code2d_org  = aws_route53_zone.code2d_org.id
    ein_com     = aws_route53_zone.ein_com.id
    ein_org     = aws_route53_zone.ein_org.id
    flame_com   = aws_route53_zone.flame_com.id
    flame_org   = aws_route53_zone.flame_org.id
    pen_com     = aws_route53_zone.pen_com.id
    pen_org     = aws_route53_zone.pen_org.id
    raviqqe_com = aws_route53_zone.raviqqe_com.id
    ytoyama_com = aws_route53_zone.ytoyama_com.id
  }
}

resource "aws_kms_key" "dnssec" {
  provider = aws.us_east_1

  key_spec                = "ECC_NIST_P256"
  deletion_window_in_days = 7
  key_usage               = "SIGN_VERIFY"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnableIamUserPermissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "AllowRoute53Dnssec"
        Effect = "Allow"
        Principal = {
          Service = "dnssec-route53.amazonaws.com"
        }
        Action = [
          "kms:DescribeKey",
          "kms:GetPublicKey",
          "kms:Sign",
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.id
          }
        }
      },
    ]
  })
}

resource "aws_route53_key_signing_key" "main" {
  for_each = local.zones

  hosted_zone_id             = each.value
  key_management_service_arn = aws_kms_key.dnssec.arn
  name                       = each.key
}

resource "aws_route53_hosted_zone_dnssec_signing" "main" {
  for_each = local.zones

  hosted_zone_id = aws_route53_key_signing_key.main[each.key].hosted_zone_id
}
