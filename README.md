# CloudGuard WAFaaS DNS records management using Terraform

## Modules

### Terraform module cloudguard-waf-dns

Module that visits all WAFaaS Profiles in WAF tenant defined by API key in variables `WAFKEY` and `WAFSECRET`
and returns certificate validation CNAMES `dns_cert_validation_cnames` and service hostnames `dns_service_domains` that can be used with custom Terraform code for DNS management.
(A records are used for root domains - domains without www. prefix)

Examples: [main.tf](./main.tf)


### Terraform module waf-cloudflare-dns

Module that manages DNS records for WAF assets in Cloudflare DNS service based on `cloudguard-waf-dns` module results.

It takes `dns_domain`, `dns_cert_validation_cnames` and `dns_service_domains` as input variables
together with CloudFlare DNS `CLOUDFLARE_ZONE_ID` and `CLOUDFLARE_API_TOKEN`.

Examples: [cloudguard.rocks.tf](./cloudguard.rocks.tf), [klaud.online.tf](./klaud.online.tf)
