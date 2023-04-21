
# Create S3 bucket for terraform to use
resource "aws_s3_bucket" "velero_s3_backup" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  bucket = "${var.clusters[count.index].cluster_backup_bucket}"
 
  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }
}
# Create S3 bucket for terraform to use
resource "aws_s3_bucket" "velero_additional_s3_backup" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  bucket = "${var.clusters[count.index].cluster_additional_backup_bucket}"
 
  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }
}

# Create versioning for the bucket
resource "aws_s3_bucket_versioning" "velero_s3_backup_enabled" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  bucket = aws_s3_bucket.velero_s3_backup[count.index].id
  versioning_configuration {
    status = "Enabled"
  }
}


# Create versioning for the bucket
resource "aws_s3_bucket_versioning" "velero_s3_additional_backup_enabled" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  bucket = aws_s3_bucket.velero_additional_s3_backup[count.index].id
  versioning_configuration {
    status = "Enabled"
  }
}


# Encrypt the data in the bucket by default
resource "aws_s3_bucket_server_side_encryption_configuration" "velero_s3_backup_default" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  bucket = aws_s3_bucket.velero_s3_backup[count.index].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Encrypt the data in the bucket by default
resource "aws_s3_bucket_server_side_encryption_configuration" "velero_s3_additional_backup_default" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  bucket = aws_s3_bucket.velero_additional_s3_backup[count.index].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "velero_s3_backup_public_access" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  bucket = aws_s3_bucket.velero_s3_backup[count.index].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Block all public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "velero_s3_additional_backup_public_access" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  bucket = aws_s3_bucket.velero_additional_s3_backup[count.index].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

