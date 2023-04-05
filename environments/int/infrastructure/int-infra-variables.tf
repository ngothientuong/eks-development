################################
# Variable for the resources   #
################################
variable vpc_tags {
  type = map
  default = {}
}
## VPC, IGW
variable "local_project_cidr" {
  type = string    
}
variable "local_env" {
  type = string    
}

variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources). Answer true/false "
  type        = bool
  #default     = true
}

variable "secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks to associate with the VPC to extend the IP Address pool"
  type        = list(string)
  #default     = []
}

variable "enable_dhcp_options" {
  description = "Should be true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type"
  type        = bool
  #default     = true
}

variable "dhcp_options_domain_name" {
  description = "Specifies DNS name for DHCP options set (requires enable_dhcp_options set to true)"
  type        = string
  #default     = ""
}

variable "dhcp_options_domain_name_servers" {
  description = "Specify a list of DNS server addresses for DHCP options set, default to AWS provided (requires enable_dhcp_options set to true)"
  type        = list(string)
  #default     = ["AmazonProvidedDNS"]
}

variable "dhcp_options_ntp_servers" {
  description = "Specify a list of NTP servers for DHCP options set (requires enable_dhcp_options set to true)"
  type        = list(string)
  #default     = []
}

variable "dhcp_options_netbios_name_servers" {
  description = "Specify a list of netbios servers for DHCP options set (requires enable_dhcp_options set to true)"
  type        = list(string)
  #default     = []
}

variable "dhcp_options_netbios_node_type" {
  description = "Specify netbios node_type for DHCP options set (requires enable_dhcp_options set to true)"
  type        = string
  #default     = ""
}


###############################
#  Variables from user.tfvars #
###############################
variable "aws_access_key" {
  type = string
  //default = "TF_VAR_aws_access_key"  
}
variable "aws_secret_key" {
  type = string
  //default = "TF_VAR_aws_secret_key"
}
variable "dynamodb_table_name" {
  type = string    
}
variable "s3_bucket_name" {
  type = string    
}
variable "project_id" {
  type = string    
}
variable "project_name" {
  type = string    
}
variable "project_domain" {
  type = string    
}
variable "project_archive" {
  type = string    
}
variable "user_state" {
  type = string    
}
variable "aws_region" {
  type = string  
  default = "us-east-2"
    
}
variable "aws_ec2_key_name" {
  type = string    
}
variable "aws_ami_name" {
  type = string    
}
variable "aws_instance_profile" {
  type = string    
}
variable "rancher_url" {
  type = string    
}
variable "cluster_kubernetes_version" {
  type = string    
}
variable "cluster_etcd_instance_type" {
  type = string    
}
variable "cluster_cp_instance_type" {
  type = string    
}
variable "cluster_worker_instance_type" {
  type = string    
}
variable "cluster_worker_asg_instance_type" {
  type = string    
}
variable "dockerhub_registry_url" {
  type = string    
}
variable "docker_registry_url" {
  type = string    
}
variable "helm_catalog_url" {
  type = string    
}
variable "elasticsearch_url" {
  type = string    
}
variable "logstash_url" {
  type = string    
}


