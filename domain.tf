locals {
  domains = [
    "cloe-lang.org",
    "code2d.net",
    "code2d.org",
    "ein-lang.com",
    "ein-lang.org",
    "flame-lang.com",
    "flame-lang.org",
    "pen-lang.com",
    "pen-lang.org",
    "raviqqe.com",
    "ytoyama.com",
  ]
}

resource "aws_route53domains_registered_domain" "main" {
  for_each = toset(local.domains)

  domain_name   = each.key
  transfer_lock = true
}
