# S3 Bucket to store Home Assistant backups
resource "aws_s3_bucket" "this" {
    bucket = var.home_assistant_backup_bucket

    tags = {
        "Homelab" = null
    }
}


# IAM Policy to allow users to access the backup bucket
resource "aws_iam_policy" "this" {
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
                    "arn:aws:s3:::${aws_s3_bucket.this.id}",
                    "arn:aws:s3:::${aws_s3_bucket.this.id}/*"
                ]
            }
        ]
    })
}

# Create a new IAM user for Home Assistant S3 access
resource "aws_iam_user" "this" {
    name = "home_assistant_backup_user"
}

# Attach the backup policy to the IAM user
resource "aws_iam_user_policy_attachment" "this" {
    user       = aws_iam_user.this.name
    policy_arn = aws_iam_policy.this.arn
}

# Create access keys for the IAM user
resource "aws_iam_access_key" "this" {
    user = aws_iam_user.this.name
}