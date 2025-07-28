terraform {

  required_providers {

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.30.0"
    }

  }
}


provider "cloudflare" {
  api_token = var.CLOUDFLARE_DNS_API_TOKEN
}