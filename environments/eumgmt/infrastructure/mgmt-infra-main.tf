data "aws_availability_zones" "available" {}

data "aws_vpc" "vpc_main" {
    count = var.create_vpc ? 0 : 1
    tags = {
        Group = var.local_env
        Name = "${format("%s%s%s",var.project_id,"-",var.local_env)}"
        Project = var.project_name
        VPC = "${format("%s%s%s",var.project_id,"-",var.local_env)}"
    }
}

data "aws_vpc_dhcp_options" "vpc_dhcp_options" {
    count = var.create_vpc ? 0 : 1
    tags = {
        Group = var.local_env
        Name = "${format("%s%s%s",var.project_id,"-",var.local_env)}"
        Project = var.project_name
        VPC = "${format("%s%s%s",var.project_id,"-",var.local_env)}"
    }

}

locals {
  tags = {
    Group = "${var.local_env}"
    Name = "${format("%s%s%s",var.project_id,"-",var.local_env)}"
    Project = "${var.project_name}"
    VPC = "${format("%s%s%s",var.project_id,"-",var.local_env)}"
  }     
  # VPC
  #vpc_id = data.aws_vpc.vpc_main[count.index].id
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)
  vpc_cidr = var.local_project_cidr
  vpc_cdir_elements = split(".",local.vpc_cidr)  
  public_subnets = [for myidx in range(length(local.azs)) : join(".",[local.vpc_cdir_elements[0],local.vpc_cdir_elements[1], tostring(tonumber(local.vpc_cdir_elements[2]) + myidx * 2 )  ,replace(local.vpc_cdir_elements[3],"/16","/24" )  ]) ]
  private_subnets = [for myidx in range(length(local.azs)) : join(".",[local.vpc_cdir_elements[0],local.vpc_cdir_elements[1], tostring(tonumber(local.vpc_cdir_elements[2]) + myidx * 2 + 1 )  ,replace(local.vpc_cdir_elements[3],"/16","/24" )  ]) ]

}

# Create VPC
module "vpc_creation" {
    source = "../../../modules/aws/vpc"
    count = var.create_vpc ? 1 : 0 # If VPC already exists, then do not create. If default to 0, it'll destroy the VPC

    create_vpc = "${var.create_vpc}"  
    project_cidr = "${var.local_project_cidr}"
    env          = "${var.local_env}"    
    project_name = "${var.project_name}"
    project_id   = "${var.project_id}"
    
    # secondary_cidr_blocks
    secondary_cidr_blocks = "${var.secondary_cidr_blocks}"
    # DHCP Options Set
    enable_dhcp_options = "${var.enable_dhcp_options}"
    dhcp_options_domain_name = "${var.dhcp_options_domain_name}"
    dhcp_options_domain_name_servers = "${var.dhcp_options_domain_name_servers}"
    dhcp_options_ntp_servers = "${var.dhcp_options_ntp_servers}"
    dhcp_options_netbios_name_servers = "${var.dhcp_options_netbios_name_servers}"
    dhcp_options_netbios_node_type = "${var.dhcp_options_netbios_node_type}"
    
    vpc_tags = local.tags
}

