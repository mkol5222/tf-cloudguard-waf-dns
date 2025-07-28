# IN local.profile_ids - list of WAFaaS profile IDs in this tenant
# IN  local.waf_api_url

# OUT local.dns_cert_validation_cnames - list of validation CNAMEs for WAF asset domains
# OUT regionForProfileId - mapping of profile IDs to their respective regions

locals {
  # query could be simplified to only fetch the required fields
  getProfile_query = <<EOT
    query Profile($id: ID!) { getProfile(id: $id) {
id name profileType status additionalSettings {
     id
    key
    value
    __typename
    }
    tags {
      id
      tag
      __typename
    }
    latestEnforcedPolicy {
      timestamp
      version
      __typename
    }
    objectStatus
    numberOfAgents
    numberOfOutdatedAgents
    usedBy {
      id
      name
      subType
      __typename
    }
    ... on KubernetesProfile {
      profileSubType
      maxNumberOfAgents
      authentication {
        authenticationType
        tokens {
          token
          id
          expirationTime
          __typename
        }
        __typename
      }
      upgradeMode
      upgradeTime {
        duration
        time
        scheduleType
        ... on ScheduleDaysInMonth {
          days
          __typename
        }
        ... on ScheduleDaysInWeek {
          weekDays
          __typename
        }
        __typename
      }
      onlyDefinedApplications
      failOpenInspection
      managerInfo {
        managerId
        managerName
        __typename
      }
      profileManagedBy
      __typename
    }
    ... on VirtualNSaaSProfile {
      cloudVendor
      cloudAccounts {
        id
        accountId
        accountRegions {
          id
          regionName
          vpcEndpointService
          __typename
        }
        __typename
      }
      managerInfo {
        managerId
        managerName
        __typename
      }
      ARNOutboundCertificate
      __typename
    }
    ... on AppSecSaaSProfile {
      region
      maxNumberOfAgents
      failOpenInspection
      certificateDomains {
        id
        domain
        certificateParameter {
          id
          ... on CertificateParameter {
            isCPManaged
            certificateFile {
              id
              name
              __typename
            }
            keyName
            certificateFileName
            certificateExpirationDate
            certificateARN
            certificateARNForCloudfront
            __typename
          }
          __typename
        }
        cnameName
        cnameValue
        certificateValidationStatus
        validationInfo
        __typename
      }
      usedByType {
        assets {
          id
          name
          ... on WebApplicationAsset {
            URLs {
              id
              URL
              __typename
            }
            upstreamURL
            __typename
          }
          __typename
        }
        __typename
      }
      __typename
    }
    ... on EmbeddedProfile {
      profileSubType
      maxNumberOfAgents
      authentication {
        authenticationType
        tokens {
          token
          id
          expirationTime
          __typename
        }
        __typename
      }
      upgradeMode
      upgradeTime {
        duration
        time
        scheduleType
        ... on ScheduleDaysInMonth {
          days
          __typename
        }
        ... on ScheduleDaysInWeek {
          weekDays
          __typename
        }
        __typename
      }
      failOpenInspection
      onlyDefinedApplications
      profileManagedBy
      managedByNginx
      __typename
    }
    ... on QuantumProfile {
      cloudId
      maxNumberOfAgents
      numberOfAgents
      authentication {
        authenticationType
        tokens {
          token
          id
          expirationTime
          __typename
        }
        __typename
      }
      upgradeMode
      upgradeTime {
        duration
        time
        scheduleType
        ... on ScheduleDaysInMonth {
          days
          __typename
        }
        ... on ScheduleDaysInWeek {
          weekDays
          __typename
        }
        __typename
      }
      __typename
    }
    ... on DockerProfile {
      profileSubType
      maxNumberOfAgents
      vendor
      isSelfManaged
      authentication {
        authenticationType
        tokens {
          token
          id
          expirationTime
          __typename
        }
        __typename
      }
      upgradeMode
      upgradeTime {
        duration
        time
        scheduleType
        ... on ScheduleDaysInMonth {
          days
          __typename
        }
        ... on ScheduleDaysInWeek {
          weekDays
          __typename
        }
        __typename
      }
      onlyDefinedApplications
      failOpenInspection
      managerInfo {
        managerId
        managerName
        __typename
      }
      profileManagedBy
      managedByNginx
      __typename
    }
    ... on CloudNativeProfile {
      maxNumberOfAgents
      authentication {
        authenticationType
        tokens {
          token
          id
          expirationTime
          __typename
        }
        __typename
      }
      upgradeMode
      upgradeTime {
        duration
        time
        scheduleType
        ... on ScheduleDaysInMonth {
          days
          __typename
        }
        ... on ScheduleDaysInWeek {
          weekDays
          __typename
        }
        __typename
      }
      onlyDefinedApplications
      __typename
    }
    ... on CloudGuardAppSecGatewayProfile {
      profileSubType
      certificateType
      maxNumberOfAgents
      authentication {
        authenticationType
        tokens {
          token
          id
          expirationTime
          __typename
        }
        __typename
      }
      upgradeMode
      upgradeTime {
        duration
        time
        scheduleType
        ... on ScheduleDaysInMonth {
          days
          __typename
        }
        ... on ScheduleDaysInWeek {
          weekDays
          __typename
        }
        __typename
      }
      usedByType {
        assets {
          id
          name
          assetType
          class
          category
          family
          group
          order
          kind
          tags {
            id
            tag
            __typename
          }
          ... on WebApplicationAsset {
            URLs {
              id
              URL
              __typename
            }
            upstreamURL
            __typename
          }
          __typename
        }
        __typename
      }
      reverseProxyUpstreamTimeout
      reverseProxyAdditionalSettings {
        key
        value
        __typename
      }
      failOpenInspection
      __typename
    }
    ... on IotEnforcementProfile {
      policyPackagesWithIotLayer {
        id
        name
        type
        subType
        __typename
      }
      enforceIotLayerOnGateways {
        id
        name
        type
        subType
        __typename
      }
      enforceIotLayerOnAllGateways
      installPolicyOnEnforce
      __typename
    }
    ... on IotConfigurationVirtualProfile {
      iotState
      shouldEnforceBetaRules
      configurationsSettings {
        id
        key
        value
        __typename
      }
      __typename
    }
    ... on IotConfigurationProfile {
      iotState
      shouldEnforceBetaRules
      configurationsSettings {
        id
        key
        value
        __typename
      }
      __typename
    }
    ... on IotBuiltinDiscoveryProfile {
      numberOfLogicalAgents
      additionalSettings {
        id
        key
        value
        __typename
      }
      integrationType
      arguments
      dnsProbing
      mdnsProbing
      upnpProbing
      snmpProbing
      sshProbing
      httpProbing
      telnetProbing
      ftpProbing
      matchQuery
      installDiscoveryOnMgmt
      installDiscoveryOnAllGateWays
      installDiscoveryOn {
        id
        name
        type
        subType
        __typename
      }
      enforceAssetsOnPolicyPackages {
        id
        name
        type
        subType
        __typename
      }
      sendAssetsToGateways
      __typename
    }
    ... on IotRiskProfile {
      numberOfLogicalAgents
      matchQuery
      overrideSettings
      configurationSettings
      installDiscoveryOnMgmt
      installDiscoveryOnAllGateWays
      installDiscoveryOn {
        id
        name
        type
        subType
        __typename
      }
      runActiveNmapProbing
      __typename
    }
    ... on SdWanProfile {
      matchQuery
      SdWanGateways {
        id
        name
        objectStatus
        __typename
      }
      numberOfAgents
      __typename
    }
    ... on IoTEmbeddedProfile {
      maxNumberOfAgents
      authentication {
        authenticationType
        tokens {
          token
          id
          expirationTime
          __typename
        }
        __typename
      }
      upgradeMode
      upgradeTime {
        duration
        time
        scheduleType
        ... on ScheduleDaysInMonth {
          days
          __typename
        }
        ... on ScheduleDaysInWeek {
          weekDays
          __typename
        }
        __typename
      }
      failOpenInspection
      onlyDefinedApplications
      profileManagedBy
      __typename
    }
    __typename
  }
}
EOT

}

# GraphQL request per profile ID
data "http" "profile" {

  for_each = toset(local.profile_ids)

  url = local.waf_api_url

  method = "POST"
  request_headers = {
    "authorization" = "Bearer ${local.token_waf}"
    "content-type"  = "application/json"
  }

  # per profile ID
  request_body = jsonencode({
    "variables" : { "id" : "${each.key}" },
    "query" : local.getProfile_query
  })

}

locals {

  dns_cert_validation_cnames = flatten([for p in data.http.profile : jsondecode(p.response_body)["data"]["getProfile"].certificateDomains])

  decoded_profiles = [for p in data.http.profile : jsondecode(p.response_body)["data"]["getProfile"]]

  regionForProfileId = {
    for p in local.decoded_profiles :
    p.id => {
      name   = p.name
      region = try(p.region, null)
    }
  }

  #   regionForProfileId = {
  #     for p in data.http.profile :
  #     p.key => (
  #       try(
  #         jsondecode(p.response_body)["data"]["getProfile"],
  #         null
  #       )
  #     )
  #   }
}