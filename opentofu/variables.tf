variable "ssh_pubkey" {
  description = "SSH public key for all nodes"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOBt423fvkSC8SeKVPPAl3MFpwvzwBZ8XEBd4/KrINoP"
}

variable "home_assistant_backup_bucket" {
  description = "S3 Bucket name for Home Assistant backups"
  type        = string
  default     = "home-assistant.coble.casa"
}