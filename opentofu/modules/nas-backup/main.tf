# Hot S3 bucket — Rustic metadata (index, snapshots, keys, config)
resource "aws_s3_bucket" "hot" {
  bucket = var.hot_bucket

  tags = {
    "Homelab" = null
  }
}

resource "aws_s3_bucket_versioning" "hot" {
  bucket = aws_s3_bucket.hot.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Cold S3 bucket — Rustic data pack files (Glacier Deep Archive)
resource "aws_s3_bucket" "cold" {
  bucket = var.cold_bucket

  tags = {
    "Homelab" = null
  }
}

# Lifecycle rule transitions all objects to Glacier Deep Archive after 1 day.
# Rustic sets the storage class directly on cold-bucket writes via options-cold,
# so this acts as a safety net for any objects that slip through.
resource "aws_s3_bucket_lifecycle_configuration" "cold" {
  bucket = aws_s3_bucket.cold.id

  rule {
    id     = "glacier-deep-archive"
    status = "Enabled"

    filter {}

    transition {
      days          = 1
      storage_class = "DEEP_ARCHIVE"
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# Expire old object versions on the hot bucket to prevent unbounded accumulation.
resource "aws_s3_bucket_lifecycle_configuration" "hot" {
  bucket = aws_s3_bucket.hot.id

  rule {
    id     = "expire-noncurrent-versions"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 30
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 3
    }
  }
}

# IAM policy granting Rustic access to both buckets.
# RestoreObject is required on the cold bucket to retrieve data from Glacier.
resource "aws_iam_policy" "this" {
  name = "nas_rustic_backup_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowHotBucketAccess"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts",
        ]
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.hot.id}",
          "arn:aws:s3:::${aws_s3_bucket.hot.id}/*",
        ]
      },
      {
        Sid    = "AllowColdBucketAccess"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts",
          "s3:RestoreObject",
        ]
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.cold.id}",
          "arn:aws:s3:::${aws_s3_bucket.cold.id}/*",
        ]
      },
    ]
  })
}

resource "aws_iam_user" "this" {
  name = "nas_rustic_backup_user"
}

resource "aws_iam_user_policy_attachment" "this" {
  user       = aws_iam_user.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}
