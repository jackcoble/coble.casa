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

# VM for Kubernetes Control Plane
module "control_plane_vm_01" {
  source      = "./modules/k8s-node"
  
  node_name = "pve"
  vm_name = "k8s-control-plane-01"
  hostname = "control-plane-01"
  cloud_image_id = proxmox_virtual_environment_download_file.rocky_linux_10_cloud_image.id
  ipv4_address   = "dhcp"
  ssh_pubkey     = var.ssh_pubkey
}

# VM for Kubernetes Worker Node 1
module "worker_node_vm_01" {
  source      = "./modules/k8s-node"
  
  node_name = "pve"
  vm_name = "k8s-worker-01"
  hostname = "worker-01"
  cloud_image_id = proxmox_virtual_environment_download_file.rocky_linux_10_cloud_image.id
  ipv4_address   = "dhcp"
  ssh_pubkey     = var.ssh_pubkey
}

# VM for Kubernetes Worker Node 2
module "worker_node_vm_02" {
  source      = "./modules/k8s-node"
  
  node_name = "pve"
  vm_name = "k8s-worker-02"
  hostname = "worker-02"
  cloud_image_id = proxmox_virtual_environment_download_file.rocky_linux_10_cloud_image.id
  ipv4_address   = "dhcp"
  ssh_pubkey     = var.ssh_pubkey
}