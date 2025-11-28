terraform {
  # Terraform State Backend Configuration
  backend "s3" {
    bucket = "coble.casa"
    key    = "coble.casa.tfstate"
    region = "eu-west-2"
    use_lockfile = true
  }

  # Providers
  required_providers {
    sops = {
      source = "nobbs/sops"
      version = "0.3.1"
    }

    proxmox = {
      source  = "bpg/proxmox"
      version = "0.87.0"
    }
  }
}

# Provider Configuration
provider "sops" {}
provider "proxmox" {}