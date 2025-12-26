provider "google" {
  project = "project_id"
  region  = "us-central1"
}

module "networking" {
  source = "../../"

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
      secondary = {}
    }
  }

  enable_nat = true

  enable_private_service_access = true
  psa_vpc_key                   = "main"
  psa_ip_cidr_range             = "10.100.0.0/16"
}
