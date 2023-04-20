resource "aws_eip" "nat" {
  count = 1

  vpc = true
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>4.0.1"

  name                = var.vpc.name
  cidr                = var.vpc.vpc_cidr
  azs                 =   var.vpc.azs
  private_subnets = var.vpc.private_subnets
  private_subnet_names = var.vpc.private_subnet_names
  private_subnet_assign_ipv6_address_on_creation = var.vpc.private_subnet_assign_ipv6_address_on_creation
  private_subnet_enable_resource_name_dns_aaaa_record_on_launch = var.vpc.private_subnet_enable_resource_name_dns_aaaa_record_on_launch    
  private_subnet_tags = { Name = "tngo-eumgmt-private" }
  public_subnets  = var.vpc.public_subnets
  public_subnet_names = var.vpc.public_subnet_names
  public_subnet_assign_ipv6_address_on_creation = var.vpc.public_subnet_assign_ipv6_address_on_creation
  public_subnet_enable_resource_name_dns_aaaa_record_on_launch = var.vpc.public_subnet_enable_resource_name_dns_aaaa_record_on_launch
  public_subnet_tags = { Name = "tngo-eumgmt-public" }
  enable_nat_gateway  = var.vpc.enable_nat_gateway
  single_nat_gateway  = var.vpc.single_nat_gateway
  enable_vpn_gateway = var.vpc.enable_vpn_gateway
  enable_ipv6 = var.vpc.enable_ipv6
  reuse_nat_ips       = true                    # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids = "${aws_eip.nat.*.id}"   # <= IPs specified here as input to the module
  tags = var.vpc.tags
  private_subnet_enable_dns64 = var.vpc.private_subnet_enable_dns64
  public_subnet_enable_dns64 = var.vpc.public_subnet_enable_dns64
}

# https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/blob/master/examples/complete/main.tf
# https://registry.terraform.io/modules/terraform-aws-modules/transit-gateway/aws/latest
module "transit-gateway" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "~>2.9.0"

  name        = var.tgw.name
  description = var.tgw.description
  amazon_side_asn = var.tgw.amazon_side_asn
  enable_auto_accept_shared_attachments = var.tgw.enable_auto_accept_shared_attachments
  enable_default_route_table_association = var.tgw.enable_default_route_table_association  # Whether resource attachments are automatically associated with the default association route table
  enable_default_route_table_propagation = var.tgw.enable_default_route_table_propagation 
  enable_mutlicast_support = var.tgw.enable_mutlicast_support
  tags = var.tgw.tags
  ram_allow_external_principals = var.tgw.ram_allow_external_principals
  vpc_attachments = {
    vpc = {
      vpc_id       = module.vpc.vpc_id
      subnet_ids   = module.vpc.private_subnets
      dns_support  = true
      ipv6_support = false

      #transit_gateway_default_route_table_association = false
      #transit_gateway_default_route_table_propagation = false

      # TGW Routes (or TGW Route Tables) are NOT needed for VPC Peering! VPC Peering does not have attachment concept!
      # TGW Route Tables contains Associations of TGW attachments (sources VPC) and Propagations of TGW Attachments (Destinations)
      # TGW is usually used for communication between VPCs in the SAME region!
      # The example below is VPC cidr_blocks of other VPC in the same region us-west-2
      tgw_routes = [
        {
          destination_cidr_block = module.vpc.vpc_cidr_block
        },
        {
          destination_cidr_block = "111.0.0.0/16"
        },
        {
          destination_cidr_block = "112.0.0.0/16"
        },
        {
          destination_cidr_block = "113.0.0.0/16"
        },
        {
          #blackhole              = true
          blackhole              = false
          destination_cidr_block = "0.0.0.0/0"
        }
      ]
    },
  }

}

module "vpc-security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~>4.17.2"
  create = var.vpc_sg.create
  name = var.vpc_sg.name
  description = var.vpc_sg.description
  vpc_id      =  module.vpc.vpc_id
  
  #ingress_cidr_blocks = var.vpc_sg.ingress_cidr_blocks
  #ingress_rules = var.vpc_sg.ingress_rules
  ingress_with_cidr_blocks = var.vpc_sg.ingress_with_cidr_blocks
}