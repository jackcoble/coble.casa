# Rocky Linux 10 Cloud Image Download
resource "proxmox_download_file" "rocky_linux_10_cloud_image" {
  content_type       = "import"
  datastore_id       = "local"
  file_name          = "rocky-linux-10-cloudimg-amd64.qcow2"
  node_name          = "pve"
  url                = "https://dl.rockylinux.org/pub/rocky/10/images/x86_64/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2"
  checksum           = "9fc9e9ff16888bb68ac39b0392e25c9c92684d50c85f1cce6ab549363bbc4b48"
  checksum_algorithm = "sha256"
}

# VM for DNS Server + Tailscale Subnet Router
module "tailscale_vm" {
  source         = "./modules/rocky-vm"
  
  node_name      = "pve"
  vm_name        = "dns"
  hostname       = "dns"
  cloud_image_id = proxmox_download_file.rocky_linux_10_cloud_image.id
  ipv4_address   = "dhcp"
  mac_address    = "BC:24:11:38:74:3D"
  ssh_pubkey     = var.ssh_pubkey
  cpu_cores      = 1
  memory         = 1 * 1024
}

# VM for Docker server
module "docker_vm" {
  source         = "./modules/rocky-vm"
  
  node_name      = "pve"
  vm_name        = "docker"
  hostname       = "docker"
  cloud_image_id = proxmox_download_file.rocky_linux_10_cloud_image.id
  ipv4_address   = "dhcp"
  mac_address    = "BC:24:11:38:74:3F"
  ssh_pubkey     = var.ssh_pubkey
  cpu_cores      = 4
  memory         = 32 * 1024
  disk_size      = 64
}

# VM for NAS (ZFS + SMB)
# Note: add virtual disks for the ZFS pool(s) via Proxmox after provisioning.
module "nas_vm" {
  source         = "./modules/rocky-vm"

  node_name      = "pve"
  vm_name        = "nas"
  hostname       = "nas"
  cloud_image_id = proxmox_download_file.rocky_linux_10_cloud_image.id
  ipv4_address   = "dhcp"
  mac_address    = "BC:24:11:38:74:41"
  ssh_pubkey     = var.ssh_pubkey
  cpu_cores      = 4
  memory         = 8 * 1024
  disk_size      = 32
}

# Home Assistant Backups
module "hass_backup" {
  source = "./modules/hass-backup"
}

output "hass_backup_access_key_id" {
  value = module.hass_backup.home_assistant_backup_access_key_id
}

output "hass_backup_secret_access_key" {
  value     = module.hass_backup.home_assistant_backup_secret_access_key
  sensitive = true
}
