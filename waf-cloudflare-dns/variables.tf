variable "dns_domain" {
  description = "Domain for WAF assets - e.g. cloudguard.rocks"
  type        = string
}

variable "CLOUDFLARE_ZONE_ID" {
  description = "Cloudflare Zone ID for the domain"
  type        = string
}

variable "CLOUDFLARE_DNS_API_TOKEN" {
  description = "Cloudflare DNS API token"
  type        = string
  sensitive   = true
}

variable "dns_service_domains" {
  description = "List of service domains for WAF assets"
  type = list(object({
    domain = string
    value  = string
    type   = string
  }))
}

variable "dns_cert_validation_cnames" {
  description = "List of validation CNAMEs for WAF asset domains"
  type = list(object({
    name   = string
    value  = string
    domain = string
  }))
}

