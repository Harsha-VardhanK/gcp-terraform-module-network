variable "project_id" {
  type        = string
  description = "GCP project ID"
  validation {
    condition     = length(var.project_id) > 0
    error_message = "project_id must not be empty"
  }
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

variable "enable_private_service_access" {
  description = "Enable Private Service Access for the VPC"
  type        = bool
  default     = false
}

variable "psa_vpc_key" {
  description = "VPC key where Private Service Access will be enabled"
  type        = string
  default     = null
}

variable "psa_ip_cidr_range" {
  description = "CIDR range for Private Service Access"
  type        = string
  default     = "10.100.0.0/16"
}
