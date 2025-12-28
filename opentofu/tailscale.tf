resource "tailscale_dns_configuration" "dns_config" {
    # Cloudflare DNS (Primary)
    nameservers {
        address            = "1.1.1.1"
    }

    # Cloudflare DNS (Secondary)
    nameservers {
        address            = "1.0.0.1"
    }

    # Split DNS for coble.casa domain
    split_dns {
        domain             = "coble.casa"

        nameservers {
            address            = "192.168.0.2"
        }
    }

    override_local_dns = true
    magic_dns = true
}