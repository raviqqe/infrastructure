locals {
  domain_transfer_locks = {
    "cloe-lang.com"           = true
    "cloe-lang.org"           = true
    "code2d.net"              = true
    "code2d.org"              = true
    "ein-lang.com"            = true
    "ein-lang.org"            = true
    "flame-lang.com"          = true
    "flame-lang.org"          = true
    "infini-dict.com"         = false
    "infinidict.com"          = false
    "infinity-dictionary.com" = false
    "pen-lang.com"            = true
    "pen-lang.org"            = true
    "raviqqe.com"             = true
    "ytoyama.com"             = true
  }
}

resource "aws_route53domains_registered_domain" "main" {
  for_each = local.domain_transfer_locks

  domain_name   = each.key
  transfer_lock = each.value
}
