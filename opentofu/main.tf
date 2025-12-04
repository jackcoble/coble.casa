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

# VM for Tailscale Subnet Router
module "tailscale_vm" {
  source         = "./modules/rocky-vm"
  
  node_name      = "pve"
  vm_name        = "tailscale"
  hostname       = "tailscale"
  cloud_image_id = proxmox_virtual_environment_download_file.rocky_linux_10_cloud_image.id
  ipv4_address   = "dhcp"
  ssh_pubkey     = var.ssh_pubkey
  cpu_cores      = 1
  memory         = 1 * 1024
}