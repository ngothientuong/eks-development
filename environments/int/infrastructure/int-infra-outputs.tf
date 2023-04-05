output "vpc_arn" {    
    value       = var.create_vpc ? module.vpc_creation.*.vpc_arn : data.aws_vpc.vpc_main.*.arn
    #value       = var.create_vpc ? module.vpc_creation.*.vpc_arn : data.aws_vpc.vpc_main.*.arn
    description = "The arn of the current VPC"
}

output "vpc_id" {    
    value       = var.create_vpc ? module.vpc_creation.*.vpc_id : data.aws_vpc.vpc_main.*.id
    #value       = var.create_vpc ? module.vpc_creation.*.vpc_id : data.aws_vpc.vpc_main.*.id
    description = "The id of the current VPC"
}

output "vpc_cidr_block" {
    value       = var.create_vpc ? module.vpc_creation.*.vpc_cidr_block : data.aws_vpc.vpc_main.*.cidr_block
    #value       = var.create_vpc ? module.vpc_creation.*.vpc_cidr_block : data.aws_vpc.vpc_main.*.cidr_block
    description = "The vpc_cidr_block of the current VPC"
}

output "tags" {
    value       = var.create_vpc ? module.vpc_creation.*.vpc_tags : data.aws_vpc.vpc_main.*.tags
    #value       = var.create_vpc ? module.vpc_creation.*.vpc_tags : data.aws_vpc.vpc_main.*.tags
    description = "The tags of the current VPC"
}

output "aws_vpc_dhcp_options_id" {
    value       = var.create_vpc ? module.vpc_creation.*.vpc_dhcp_options_id : data.aws_vpc_dhcp_options.vpc_dhcp_options.*.dhcp_options_id    
    description = "The aws_vpc_dhcp_options of the current VPC"
}

