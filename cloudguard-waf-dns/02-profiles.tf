
# IN:  local.waf_api_url
# OUT: local.profile_ids - list of WAFaaS profile IDs in this tenant

# GraphQL query components
locals {
  getProfiles_variables = {
    "matchSearch" : "",
    "paging" : { "offset" : 0, "limit" : 50 },
    "sortBy" : { "field" : "name", "order" : "ascending" },
    "filters" : { "profileType" : ["AppSecSaaS"] }
  }
  getProfiles_query = "query ProfilesName($matchSearch: String, $filters: ProfileFilter, $paging: Paging, $sortBy: SortBy) {\n  getProfiles(\n    matchSearch: $matchSearch\n    filters: $filters\n    paging: $paging\n    sortBy: $sortBy\n  ) {\n    id\n    name\n    __typename\n  }\n}\n"

  getProfiles_body = jsonencode({
    "variables" : local.getProfiles_variables,
    "query" : local.getProfiles_query
  })
}

# GraohQL request to get WAFaaS profiles
data "http" "profiles" {
  url    = local.waf_api_url
  method = "POST"
  request_headers = {
    "authorization" = "Bearer ${local.token_waf}"
    "content-type"  = "application/json"
  }
  request_body = local.getProfiles_body
}

# extract only profile IDs from the response
locals {
  profile_ids = [for profile in jsondecode(data.http.profiles.response_body)["data"]["getProfiles"] : profile["id"]]
}