# Ubuntu 24.04 LTS Cloud Image (QCOW2)
resource "proxmox_virtual_environment_download_file" "ubuntu_24_04_cloud_image" {
  content_type       = "import"
  datastore_id       = "local"
  file_name          = "ubuntu-24.04-server-cloudimg-amd64.qcow2"
  node_name          = "pve"
  url                = "https://cloud-images.ubuntu.com/noble/20251126/noble-server-cloudimg-amd64.img"
}

# Control Plane VM
resource "proxmox_virtual_environment_vm" "control_plane_vm" {
  name      = "k8s-control-plane"
  node_name = "pve"

  stop_on_destroy = true

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  operating_system {
    type = "l26" # Linux 2.6/3.x/4.x/5.x Kernel
  }

  disk {
    datastore_id = "local-zfs"
    import_from  = proxmox_virtual_environment_download_file.ubuntu_24_04_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }
 
  # UEFI & EFI Disk
  machine = "q35"
  bios = "ovmf"
  efi_disk {
    datastore_id = "local-zfs"
    type = "4m"
  }

  initialization {
    # uncomment and specify the datastore for cloud-init disk if default `local-lvm` is not available
    datastore_id = "local"

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_device {
    bridge = "vmbr0"
  }
}