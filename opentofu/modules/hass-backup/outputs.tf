output "home_assistant_backup_access_key_id" {
    value       = aws_iam_access_key.this.id
    description = "Access Key ID for Home Assistant backup user"
}

output "home_assistant_backup_secret_access_key" {
    value       = aws_iam_access_key.this.secret
    description = "Secret Access Key for Home Assistant backup user"
    sensitive   = true
}

output "home_assistant_backup_bucket_name" {
  value = aws_s3_bucket.this.id
}