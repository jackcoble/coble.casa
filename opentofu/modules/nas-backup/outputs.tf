output "rustic_access_key_id" {
  value = aws_iam_access_key.this.id
}

output "rustic_secret_access_key" {
  value     = aws_iam_access_key.this.secret
  sensitive = true
}

output "hot_bucket_name" {
  value = aws_s3_bucket.hot.id
}

output "cold_bucket_name" {
  value = aws_s3_bucket.cold.id
}
