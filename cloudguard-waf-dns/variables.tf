variable "WAFKEY" {
  description = "API KEY: The client ID of CloudGuard WAF app in Infinite Portal"
  type        = string
}

variable "WAFSECRET" {
  description = "API KEY: The secret key of CloudGuard WAF app in Infinite Portal"
  type        = string
  sensitive   = true
}