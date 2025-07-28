# IN: var.WAFKEY, var.WAFSECRET
# OUT: locals.token_waf - API token valid for 30 minutes

data "http" "login_waf" {
  url    = "https://cloudinfra-gw.portal.checkpoint.com/auth/external"
  method = "POST"
  request_body = jsonencode({
    clientId  = var.WAFKEY
    accessKey = var.WAFSECRET
  })
  request_headers = {
    "content-type" = "application/json"
  }
}

locals {
  # token valid 30 minutes since login
  token_waf = jsondecode(data.http.login_waf.response_body)["data"]["token"]
}