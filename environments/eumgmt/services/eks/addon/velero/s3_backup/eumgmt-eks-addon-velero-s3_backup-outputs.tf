output "velero_s3_backup" {
  value       = aws_s3_bucket.velero_s3_backup
  description = "The ARN of the S3 backup bucket"
}

output "velero_additional_s3_backup" {
  value       = aws_s3_bucket.velero_additional_s3_backup
  description = "The ARN of the additional S3 backup bucket"
}

