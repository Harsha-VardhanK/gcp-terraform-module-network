project_id = "my-sample-project"
region     = "us-central1"

vpcs = {
  main = {
    name = "main-vpc"
  }
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
