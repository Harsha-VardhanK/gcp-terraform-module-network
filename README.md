
# Terraform GCP Networking Module

This Terraform module creates **VPC networks, subnets, and optionally Cloud NAT** on Google Cloud Platform (GCP).  
It is designed for use in **production-ready multi-project environments** and follows best practices for modular Terraform.

---

## Features

- Create **VPC networks** with `auto_create_subnetworks = false`
- Create **subnets** with optional secondary IP ranges for GKE
- Create **Cloud NAT** for private GKE clusters or private subnets
- Multi-project ready (via Terraform variables)
- Terraform Registry style, versioned, reusable

---

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.5.0 |
| Google Provider | >= 6.0 |

---

## Inputs

| Name | Description | Type | Default | Required |
|------|------------|------|--------|----------|
| `project_id` | GCP project ID | `string` | n/a | yes |
| `region` | GCP region | `string` | n/a | yes |
| `vpcs` | Map of VPC definitions | `map(object({name=string}))` | n/a | yes |
| `subnets` | Map of subnet definitions with `vpc_key`, `name`, `region`, `cidr`, `secondary` ranges | `map(object({...}))` | n/a | yes |
| `enable_nat` | Enable Cloud NAT for private subnets | `bool` | `false` | no |

**Example `subnets` object:**

```hcl
subnets = {
  gke = {
    vpc_key   = "main"
    name      = "gke-subnet"
    region    = "us-central1"
    cidr      = "10.10.0.0/16"
    secondary = {
      pods     = "10.20.0.0/16"
      services = "10.30.0.0/20"
    }
  }
}

Outputs
Name	Description
vpcs	Map of VPC IDs created
subnets	Map of subnet names created
nat_router	Name of the NAT router (if enabled)
nat_config	Name of the NAT config (if enabled)
Example Usage
provider "google" {
  project = "my-sample-project"
  region  = "us-central1"
}

module "networking" {
  source = "git::https://github.com/YOUR-ORG/gcp-terraform-module-network.git?ref=v1.0.0"

  project_id = "my-sample-project"
  region     = "us-central1"

  vpcs = {
    main = { name = "main-vpc" }
  }

  subnets = {
    gke = {
      vpc_key   = "main"
      name      = "gke-subnet"
      region    = "us-central1"
      cidr      = "10.10.0.0/16"
      secondary = {
        pods     = "10.20.0.0/16"
        services = "10.30.0.0/20"
      }
    }
  }

  enable_nat = true
}

Notes

For private GKE clusters, enable_nat = true is recommended.

This module is multi-project ready; you can reference VPC and subnets from different service/host projects using Terraform provider aliases.