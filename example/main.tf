module "wafdns" {
    source = "git::https://github.com/mkol5222/tf-cloudguard-waf-dns.git//cloudguard-waf-dns?ref=v1.0.0"
    WAFKEY  = var.WAFKEY
    WAFSECRET = var.WAFSECRET
}

variable "WAFKEY" {}
variable "WAFSECRET" {}

output "dns_cert_validation_cnames" {
  value = module.wafdns.dns_cert_validation_cnames
}
output "dns_service_domains" {
  value = module.wafdns.dns_service_domains
}