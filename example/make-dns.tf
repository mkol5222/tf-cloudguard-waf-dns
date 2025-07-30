
locals {
    relevant_validation_cnames = [
        for cname in module.wafdns.dns_cert_validation_cnames : cname
        if cname.name != null && cname.name != "" # && endswith(cname.domain, "${var.dns_domain}")
    ]
}

# run script for all
resource "null_resource" "dns-validate" {
    for_each = { for cname in local.relevant_validation_cnames : cname.name => cname }
    
    provisioner "local-exec" {
        command = "echo '[ALL] Here do the job: DNS validation CNAME: ${each.value.name} for domain ${each.value.domain} with value ${each.value.value}'"
    }
}

# run script for specific domain like cloudguard.rocks
locals {
    specific_domain = "cloudguard.rocks"
    specific_domain_validation_cnames = [
        for cname in local.relevant_validation_cnames : cname
        if endswith(cname.domain, local.specific_domain)
    ]
}

resource "null_resource" "dns-validate-spec" {
    for_each = { for cname in local.specific_domain_validation_cnames : cname.name => cname }

    provisioner "local-exec" {
        # command = "echo '[SPECIFIC]Here do the job: DNS validation CNAME: ${each.value.name} for domain ${each.value.domain} with value ${each.value.value}'"
        command = "./make-dns.sh CERT_VALIDATION ${each.value.name} ${each.value.value} ${each.value.domain} 'specific domain cert validation CNAME'"
    }
}