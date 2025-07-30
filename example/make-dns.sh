#!/bin/bash

# here put custom DNS record creation logic

DNS_TYPE=$1
DNS_NAME=$2
DNS_VALUE=$3
DNS_DOMAIN=$4
DNS_COMMENT=$5

if [ -z "$DNS_TYPE" ] || [ -z "$DNS_NAME" ] || [ -z "$DNS_VALUE" ] || [ -z "$DNS_DOMAIN" ]; then
    echo "Usage: $0 <dns_type> <dns_name> <dns_value> <dns_domain> [comment]"
    exit 1
fi

echo
# for type CERT_VALIDATION
if [ "$DNS_TYPE" == "CERT_VALIDATION" ]; then
    echo "Creating DNS record for certificate validation of domain $DNS_DOMAIN"
  
    echo "   CNAME $DNS_NAME -> $DNS_VALUE"
    
    if [ -n "$DNS_COMMENT" ]; then
        echo "   Comment: $DNS_COMMENT"
    fi
    # Here you would add the actual command to create/update the DNS record, e.g. using an API or CLI tool.

    echo
else
    echo "Unsupported DNS type: $DNS_TYPE"
    exit 1
fi