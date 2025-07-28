output "dns_cert_validation_cnames" {
  description = "DNS validation CNAMEs for WAF asset domains"
  value = [
    for cname in local.dns_cert_validation_cnames : {
      status = cname.certificateValidationStatus
      name   = cname.cnameName
      value  = cname.cnameValue
      domain = cname.domain
    }
  ]
}

output "dns_service_domains" {
  description = "List of service CNAMES for WAF asset domains"
  value = [for domain in flatten(local.service_domains) : {
    domain = domain.domain
    value  = domain.recordValue
    type   = domain.recordType
  }]
}

# "certificateValidationStatus" = "SUCCESS"
# "cnameName" = "_881679ca795ba3c12ec2bfc5006bb713.cloudguard.rocks."
# "cnameValue" = "_55e471524409e1ad4aeb7ae008b315f4.xlfgrmvvlj.acm-validations.aws."
# "domain" = "cloudguard.rocks"