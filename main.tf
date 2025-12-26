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
