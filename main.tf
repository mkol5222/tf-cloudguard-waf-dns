

module "waf-dns" {
  source = "./cloudguard-waf-dns"

  WAFKEY    = var.WAFKEY
  WAFSECRET = var.WAFSECRET
}

variable "WAFKEY" {
  description = "API KEY: The client ID of CloudGuard WAF app in Infinite Portal"
  type        = string
}

variable "WAFSECRET" {
  description = "API KEY: The secret key of CloudGuard WAF app in Infinite Portal"
  type        = string
  sensitive   = true
}

# cert validation_cnames
output "dns_cert_validation_cnames" {
  description = "list of validation CNAMEs for WAF asset domains"
  value       = module.waf-dns.dns_cert_validation_cnames
}


# dns_service_domains
output "dns_service_domains" {
  description = "List of service domains for WAF assets"
  value       = module.waf-dns.dns_service_domains
}


