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


### Terraform inpts

This can be provided by `.env` file or by environment variables.

```shell
# WAF lab tenant
TF_VAR_WAFKEY=xxx
TF_VAR_WAFSECRET=xxx

# klaud.online
TF_VAR_CLOUDFLARE_DNS_API_TOKEN_KLAUD_ONLINE=xxx
TF_VAR_CLOUDFLARE_ZONE_ID_KLAUD_ONLINE=xxx

# cloudguard.rocks
TF_VAR_CLOUDFLARE_DNS_API_TOKEN_CLOUDGUARD_ROCKS=xxx
TF_VAR_CLOUDFLARE_ZONE_ID_CLOUDGUARD_ROCKS=xxx
```

## Lab usage

Check `Makefile` and actions like `make apply` and `make destroy`.

## Links

- [dotenvx](https://dotenvx.com/)
- [CloudGuard WAF docs](https://waf-doc.inext.checkpoint.com/)