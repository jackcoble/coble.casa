# S3 Bucket to store Home Assistant backups
resource "aws_s3_bucket" "home_assistant_backup_bucket" {
    bucket = var.home_assistant_backup_bucket

    tags = {
        "Homelab" = null
    }
}

# IAM Policy to allow users to access the backup bucket
resource "aws_iam_policy" "home_assistant_backup_policy" {
    name = "home_assistant_backup_policy"

    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AllowS3BackupOperations",
                "Effect": "Allow",
                "Action": [
                    "s3:ListBucket",
                    "s3:GetObject",
                    "s3:PutObject",
                    "s3:DeleteObject",
                    "s3:AbortMultipartUpload"
                ],
                "Resource": [
                    "arn:aws:s3:::${aws_s3_bucket.home_assistant_backup_bucket.id}",
                    "arn:aws:s3:::${aws_s3_bucket.home_assistant_backup_bucket.id}/*"
                ]
            }
        ]
    })
}

# Create a new IAM user for Home Assistant S3 access
resource "aws_iam_user" "home_assistant_backup_user" {
    name = "home_assistant_backup_user"
}

# Attach the backup policy to the IAM user
resource "aws_iam_user_policy_attachment" "home_assistant_backup_user_policy_attachment" {
    user       = aws_iam_user.home_assistant_backup_user.name
    policy_arn = aws_iam_policy.home_assistant_backup_policy.arn
}

# Create access keys for the IAM user
resource "aws_iam_access_key" "home_assistant_backup_access_key" {
    user = aws_iam_user.home_assistant_backup_user.name
}

# Outputs
output "home_assistant_backup_access_key_id" {
    value       = aws_iam_access_key.home_assistant_backup_access_key.id
    description = "Access Key ID for Home Assistant backup user"
}

output "home_assistant_backup_secret_access_key" {
    value       = aws_iam_access_key.home_assistant_backup_access_key.secret
    description = "Secret Access Key for Home Assistant backup user"
    sensitive   = true
}

output "home_assistant_backup_bucket_name" {
  value = aws_s3_bucket.home_assistant_backup_bucket.id
}