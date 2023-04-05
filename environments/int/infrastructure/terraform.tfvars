local_project_cidr = "103.0.0.0/16"
local_env = "int"
create_vpc = true
# VPC secondary_cidr_blocks
secondary_cidr_blocks = []

# VPC DHCP Options Set
enable_dhcp_options = true
dhcp_options_domain_name = "us-east-2.compute.internal"
dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]
dhcp_options_ntp_servers = []
dhcp_options_netbios_name_servers = []
dhcp_options_netbios_node_type = ""