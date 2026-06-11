variable "hot_bucket" {
  description = "S3 bucket for Rustic metadata (hot — standard storage class)"
  type        = string
  default     = "nas-backup-hot.coble.casa"
}

variable "cold_bucket" {
  description = "S3 bucket for Rustic data pack files (cold — Glacier Deep Archive)"
  type        = string
  default     = "nas-backup-cold.coble.casa"
}
