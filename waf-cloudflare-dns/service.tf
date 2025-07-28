

locals {
    relevant_service_cnames = [
        for d in var.dns_service_domains : d
        if endswith(d.domain, ".${var.dns_domain}") && d.type == "CNAME"
    ]

    
    relevant_service_a_records = [
        for rec in var.dns_service_domains : rec
        if rec.domain != null && rec.domain != "" && endswith(rec.domain, "${var.dns_domain}") && rec.type == "A"
    ]
    # split relevant_service_a_records by value "166.117.42.30|76.223.1.245" into separate records by char "|"
    relevant_service_a_records_split = flatten( [
        for rec in local.relevant_service_a_records : [
            for ip in split("|", rec.value) : {
                name  = "${rec.domain}.${var.dns_domain}"
                value = ip
                type  = "A"
            }
        ]
    ])
}

resource "cloudflare_record" "service" {
  
  for_each = { for entry in local.relevant_service_cnames : entry.domain => entry }

  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = "${each.value.domain}."
  value   = each.value.value
  type    = "CNAME"
  ttl     = 3600

  comment = "[waf-saas-dns-manager terraform]"
}

resource "cloudflare_record" "service_a" {

  for_each = { for entry in local.relevant_service_a_records_split : "${entry.name}-${index(local.relevant_service_a_records_split, entry)}" => entry }

  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = "${each.value.name}."
  value   = each.value.value
  type    = "A"
  ttl     = 3600

  comment = "[waf-saas-dns-manager terraform]"
}