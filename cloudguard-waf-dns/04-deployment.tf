
# IN: local.profile_ids - list of WAFaaS profile IDs in this tenant
# IN: local.waf_api_url - WAFaaS API URL
# IN: local.token_waf - API token valid for 30 minutes
# IN: local.regionForProfileId - mapping of profile IDs to their respective regions

# OUT: service_domains - list of service domains for WAF assets and domain deployment status

# getDeployment queries per profile and its region
locals {

  getDeployment_query = <<EOT
    query Deployment($profileId: String, $region: String) {
  getDeployment(profileId: $profileId, region: $region) {
    domains {
      domain
      recordType
      recordValue
      recordSecondaryValue
      recordSecondaryType
      deploymentStatus
      deploymentTasks {
        taskName
        taskStatus
        __typename
      }
      failureReason
      protectionTestResult
      __typename
    }
    natIPs
    __typename
  }
}
EOT
}

# GraphQL API query to get WAFaaS deployment details
data "http" "deployment" {

  for_each = toset(local.profile_ids)

  url    = local.waf_api_url
  method = "POST"
  request_headers = {
    "authorization" = "Bearer ${local.token_waf}"
    "content-type"  = "application/json"
  }
  request_body = jsonencode({
    "variables" : { "profileId" : "${each.key}", "region" : local.regionForProfileId[each.key].region },
    "query" : local.getDeployment_query
  })

}

locals {

  decoded_deployments = [for p in data.http.deployment : jsondecode(p.response_body)["data"]["getDeployment"]]

  service_domains = [for d in local.decoded_deployments : d["domains"]]
}
