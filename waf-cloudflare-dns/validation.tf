locals {
    relevant_validation_cnames = [
        for cname in var.dns_cert_validation_cnames : cname
        if cname.name != null && cname.name != "" && endswith(cname.domain, "${var.dns_domain}")
    ]
}

resource "cloudflare_record" "validation" {

  for_each = { for cname in local.relevant_validation_cnames : cname.name => cname }

  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = each.value.name
  value   = each.value.value
  type    = "CNAME"
  ttl     = 3600

  comment = "[waf-saas-dns-manager terraform]"
}


