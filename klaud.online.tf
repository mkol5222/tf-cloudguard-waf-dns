
module "klaud_online_dns" {
  source = "./waf-cloudflare-dns"

  dns_domain                 = "klaud.online"
  CLOUDFLARE_ZONE_ID         = var.CLOUDFLARE_ZONE_ID_KLAUD_ONLINE
  CLOUDFLARE_DNS_API_TOKEN   = var.CLOUDFLARE_DNS_API_TOKEN_KLAUD_ONLINE
  dns_service_domains        = module.waf-dns.dns_service_domains
  dns_cert_validation_cnames = module.waf-dns.dns_cert_validation_cnames
}

variable "CLOUDFLARE_ZONE_ID_KLAUD_ONLINE" {
  description = "Cloudflare Zone ID for the domain"
  type        = string
}

variable "CLOUDFLARE_DNS_API_TOKEN_KLAUD_ONLINE" {
  description = "Cloudflare DNS API token"
  type        = string
  sensitive   = true
}