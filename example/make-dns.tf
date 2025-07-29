
locals {
    relevant_validation_cnames = [
        for cname in module.wafdns.dns_cert_validation_cnames : cname
        if cname.name != null && cname.name != "" # && endswith(cname.domain, "${var.dns_domain}")
    ]
}

resource "null_resource" "dns-validate" {
    for_each = { for cname in local.relevant_validation_cnames : cname.name => cname }
    
    provisioner "local-exec" {
        command = "echo 'Here do the job: DNS validation CNAME: ${each.value.name} for domain ${each.value.domain} with value ${each.value.value}'"
    }
}