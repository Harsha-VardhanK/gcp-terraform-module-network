# -------------------------
# Local values
# -------------------------
locals {
  # Get the first VPC key for NAT (used if enable_nat = true)
  first_vpc_key = length(keys(var.vpcs)) > 0 ? keys(var.vpcs)[0] : ""
}

# -------------------------
# Create VPCs
# -------------------------
resource "google_compute_network" "vpc" {
  for_each                = var.vpcs
  project                 = var.project_id
  name                    = each.value.name
  auto_create_subnetworks = false
}

# -------------------------
# Create Subnets
# -------------------------
resource "google_compute_subnetwork" "subnet" {
  for_each      = var.subnets
  project       = var.project_id
  name          = each.value.name
  region        = each.value.region
  network       = google_compute_network.vpc[each.value.vpc_key].id
  ip_cidr_range = each.value.cidr

  dynamic "secondary_ip_range" {
    for_each = each.value.secondary
    content {
      range_name    = secondary_ip_range.key
      ip_cidr_range = secondary_ip_range.value
    }
  }
}

# -------------------------
# Optional Cloud NAT
# -------------------------
resource "google_compute_router" "nat_router" {
  count   = var.enable_nat && local.first_vpc_key != "" ? 1 : 0
  project = var.project_id
  name    = "nat-router"
  network = google_compute_network.vpc[local.first_vpc_key].id
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  count   = var.enable_nat && local.first_vpc_key != "" ? 1 : 0
  project = var.project_id
  name    = "nat-config"
  router  = google_compute_router.nat_router[0].name
  region  = var.region

  nat_ip_allocate_option              = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}


#-------Add only if PSA is enabled

# resource "google_compute_global_address" "psa_range" {
#   count         = var.enable_private_service_access ? 1 : 0
#   project       = var.project_id
#   name          = "psa-range"
#   purpose       = "VPC_PEERING"
#   address_type  = "INTERNAL"
#   prefix_length = split("/", var.psa_ip_cidr_range)[1]
#   network       = google_compute_network.vpc[var.psa_vpc_key].id
# }

# resource "google_service_networking_connection" "psa_connection" {
#   count                   = var.enable_private_service_access ? 1 : 0
#   network                 = google_compute_network.vpc[var.psa_vpc_key].id
#   service                 = "servicenetworking.googleapis.com"
#   reserved_peering_ranges = [google_compute_global_address.psa_range[0].name]
# }
