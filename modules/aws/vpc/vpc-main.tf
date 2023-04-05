resource "aws_vpc" "this" {
  # If does not exist then create. If exists, then do nothing. If default to 0, it'll destroy the VPC
  count = var.create_vpc ? 1 : 0

  cidr_block = var.project_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags= {
    Group = var.env
    Name = "${format("%s%s%s",var.project_id,"-",var.env)}"
    Project = var.project_name
    VPC = "${format("%s%s%s",var.project_id,"-",var.env)}"
   }  
  lifecycle{
    prevent_destroy = true
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "this" {
  count = var.create_vpc && length(var.secondary_cidr_blocks) > 0 ? length(var.secondary_cidr_blocks) : 0

  vpc_id = aws_vpc.this[0].id

  cidr_block = element(var.secondary_cidr_blocks, count.index)
}

####################
# DHCP Options Set #
####################
resource "aws_vpc_dhcp_options" "this" {
  count = var.create_vpc && var.enable_dhcp_options ? 1 : 0

  domain_name          = var.dhcp_options_domain_name
  domain_name_servers  = var.dhcp_options_domain_name_servers
  ntp_servers          = var.dhcp_options_ntp_servers
  netbios_name_servers = var.dhcp_options_netbios_name_servers
  netbios_node_type    = var.dhcp_options_netbios_node_type
  tags = var.vpc_tags
}

###############################
# DHCP Options Set Association
###############################
resource "aws_vpc_dhcp_options_association" "this" {
  count = var.create_vpc && var.enable_dhcp_options ? 1 : 0

  vpc_id          = aws_vpc.this[0].id
  dhcp_options_id = aws_vpc_dhcp_options.this[0].id
}