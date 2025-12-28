terraform {
  required_version = "1.10.7"

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
      version = "0.88.0"
    }

    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.24.0"
    }
  }
}

# Provider Configuration
provider "sops" {}

provider "proxmox" {
  endpoint = "https://192.168.0.100:8006/"
  api_token = provider::sops::file("../secrets/secrets.yaml", "yaml").data.proxmox_api_token
  insecure  = true
  ssh {
    agent    = true
    username = "terraform"
  }
}

provider "tailscale" {
  api_key = provider::sops::file("../secrets/secrets.yaml", "yaml").data.tailscale_api_key
  tailnet = "jackcoble.github"
}