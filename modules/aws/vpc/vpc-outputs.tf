output "vpc_id" {
  description = "The ID of the VPC"
  #value       = aws_vpc.this.*.id[0]  
  value       = concat(aws_vpc.this.*.id, [])[0]    # Same as above
}  

output "vpc_arn" {
  description = "The ARN of the VPC"
  #value       =  aws_vpc.this.*.arn[0]
  value       = concat(aws_vpc.this.*.arn, [])[0]    # Same as above
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  #value       = aws_vpc.this.*.cidr_block[0]
  value       = concat(aws_vpc.this.*.cidr_block, [])[0]    # Same as above
}


output "vpc_tags" {
  description = "The tags of the VPC"
  #value       = aws_vpc.this.*.tags[0]
  value       = concat(aws_vpc.this.*.tags, [])[0]    # Same as above
}

output "vpc_secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks of the VPC"
  value       = aws_vpc_ipv4_cidr_block_association.this.*.cidr_block
}

output "vpc_dhcp_options_id" {
  description = "The aws_vpc_dhcp_options of the current VPC"
  value       = concat(aws_vpc_dhcp_options.this.*.id, [])[0]
}

