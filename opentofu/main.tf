# Rocky Linux 10 Cloud Image Download
resource "proxmox_virtual_environment_download_file" "rocky_linux_10_cloud_image" {
  content_type       = "import"
  datastore_id       = "local"
  file_name          = "rocky-linux-10-cloudimg-amd64.qcow2"
  node_name          = "pve"
  url                = "https://dl.rockylinux.org/pub/rocky/10/images/x86_64/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2"
  checksum           = "28628abf08a134c6f9e1eccbcac3f2898715919a6da294ae2c6cd66d6bc347ad"
  checksum_algorithm = "sha256"
}

# VM for DNS Server + Tailscale Subnet Router
module "tailscale_vm" {
  source         = "./modules/rocky-vm"
  
  node_name      = "pve"
  vm_name        = "dns"
  hostname       = "dns"
  cloud_image_id = proxmox_virtual_environment_download_file.rocky_linux_10_cloud_image.id
  ipv4_address   = "dhcp"
  mac_address    = "BC:24:11:38:74:3D"
  ssh_pubkey     = var.ssh_pubkey
  cpu_cores      = 1
  memory         = 1 * 1024
}

# VM for MultiFreight Development server
module "multifreight_dev_vm" {
  source         = "./modules/rocky-vm"
  
  node_name      = "pve"
  vm_name        = "multifreight-dev"
  hostname       = "multifreight-dev"
  cloud_image_id = proxmox_virtual_environment_download_file.rocky_linux_10_cloud_image.id
  ipv4_address   = "dhcp"
  mac_address    = "BC:24:11:38:74:3E"
  ssh_pubkey     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBqp2MkLIitzT3ZnYU25wYR/GIyYpLtN9D/aH2WU5jtJ"
  cpu_cores      = 2
  memory         = 4 * 1024
}

# VM for Docker server
module "docker_vm" {
  source         = "./modules/rocky-vm"
  
  node_name      = "pve"
  vm_name        = "docker"
  hostname       = "docker"
  cloud_image_id = proxmox_virtual_environment_download_file.rocky_linux_10_cloud_image.id
  ipv4_address   = "dhcp"
  mac_address    = "BC:24:11:38:74:3F"
  ssh_pubkey     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBqp2MkLIitzT3ZnYU25wYR/GIyYpLtN9D/aH2WU5jtJ"
  cpu_cores      = 4
  memory         = 32 * 1024
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
