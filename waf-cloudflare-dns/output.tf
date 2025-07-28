
output "managed_dns_records" {
  description = "List of managed DNS records for WAF assets"
  value = concat(
    [for r in cloudflare_record.validation : r.name],
    [for r in cloudflare_record.service : r.name],
    [for r in cloudflare_record.service_a : r.name]
  )
  # sensitive = true
}