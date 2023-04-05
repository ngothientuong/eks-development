output "igw_arn" {
  value       = aws_internet_gateway.igw.arn
  description = "The arn of the current igw"
}

output "igw_id" {
  value       = aws_internet_gateway.igw.id
  description = "The id of the current igw"
}

output "igw_tags" {
  value       = aws_internet_gateway.igw.tags
  description = "The tags of the current igw"
}