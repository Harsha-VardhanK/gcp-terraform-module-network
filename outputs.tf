# -------------------------
# VPC Outputs
# -------------------------
output "vpcs" {
  description = "Map of VPC IDs created"
  value       = { for k, v in google_compute_network.vpc : k => v.id }
}

# -------------------------
# Subnet Outputs
# -------------------------
output "subnets" {
  description = "Map of subnet names created"
  value       = { for k, v in google_compute_subnetwork.subnet : k => v.name }
}

# -------------------------
# NAT Router Outputs
# -------------------------
output "nat_router" {
  description = "Name of the NAT router (if NAT enabled)"
  value       = length(google_compute_router.nat_router) > 0 ? google_compute_router.nat_router[0].name : ""
}

output "nat_config" {
  description = "Name of the NAT config (if NAT enabled)"
  value       = length(google_compute_router_nat.nat) > 0 ? google_compute_router_nat.nat[0].name : ""
}
