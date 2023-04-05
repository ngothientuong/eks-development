# Variable for the resources
variable "create_vpc" {}
variable "project_cidr" {}
variable "env" {}
#variable "vpc_name" {}
variable "project_name" {}
variable "project_id" {}
# variable secondary_cidr_blocks
variable secondary_cidr_blocks{}
variable "enable_dhcp_options" {
}
# DHCP Options Set Association
variable "dhcp_options_domain_name" {}
variable "dhcp_options_domain_name_servers" {}
variable "dhcp_options_ntp_servers" {}
variable "dhcp_options_netbios_name_servers" {}
variable "dhcp_options_netbios_node_type" {}
variable "vpc_tags" {}