resource "proxmox_virtual_environment_file" "cloud_init" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.node_name

  source_raw {
    data = templatefile("${path.module}/../../cloud-init/cloud-init.tftpl", {
      hostname   = var.hostname
      ssh_pubkey = var.ssh_pubkey
    })
    file_name = "cloud-init-${var.vm_name}.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.vm_name
  node_name = var.node_name
  tags = [ "rockylinux" ]

  agent {
    enabled = true
  }

  cpu {
    cores = var.cpu_cores
    type  = "host"
  }

  memory {
    dedicated = var.memory
  }

  operating_system {
    type = "l26"
  }

  disk {
    datastore_id = var.datastore_id
    import_from  = var.cloud_image_id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = var.disk_size
  }

  machine = "q35"
  bios    = "ovmf"

  efi_disk {
    datastore_id = var.datastore_id
    type         = "4m"
  }

  initialization {
    datastore_id = var.datastore_id
    
    ip_config {
      ipv4 {
        address = var.ipv4_address
      }
    }
    
    user_data_file_id = proxmox_virtual_environment_file.cloud_init.id
  }

  network_device {
    bridge = "vmbr0"
  }
}
