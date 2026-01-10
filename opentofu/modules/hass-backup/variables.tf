variable "home_assistant_backup_bucket" {
  description = "S3 Bucket name for Home Assistant backups"
  type        = string
  default     = "home-assistant.coble.casa"
}