variable "node_name" {
  description = "Proxmox node name"
  type        = string
}

variable "datastore_id" {
  description = "Datastore ID for VM disks"
  type        = string
  default     = "local-zfs"
}

variable "vm_name" {
  description = "VM name"
  type        = string
}

variable "hostname" {
  description = "Hostname for cloud-init"
  type        = string
}

variable "ssh_pubkey" {
  description = "SSH public key"
  type        = string
}

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memory in MB"
  type        = number
  default     = 2048
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 20
}

variable "ipv4_address" {
  description = "IPv4 address (use 'dhcp' for DHCP)"
  type        = string
  default     = "dhcp"
}

variable "mac_address" {
  description = "MAC address (optional)"
  type        = string
  default     = ""
}

variable "cloud_image_id" {
  description = "Cloud image file ID to import from"
  type        = string
}