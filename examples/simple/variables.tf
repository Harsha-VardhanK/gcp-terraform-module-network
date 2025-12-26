variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Region for subnets and NAT"
  type        = string
}

variable "vpcs" {
  description = "Map of VPC definitions"
  type = map(object({
    name = string
  }))
}

variable "subnets" {
  description = "Map of subnet definitions"
  type = map(object({
    vpc_key   = string
    name      = string
    region    = string
    cidr      = string
    secondary = map(string)
  }))
}

variable "enable_nat" {
  description = "Enable Cloud NAT for private subnets"
  type        = bool
  default     = false
}
