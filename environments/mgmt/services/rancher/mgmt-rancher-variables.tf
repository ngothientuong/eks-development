################################
# Variable for the resources   #
################################
variable "env" {
  type = string    
}
variable "project_cidr" {
  type = string  
}

variable "create_rancher_config" {
  type = bool 
  description = "Create or delete the entire rancher configuration"
  default = true  # Ensure that this is always true
}

// Boostrap module
variable "rancher_initial_password" {
  type = string 
}
// Rancher EKS IAM Role and Policies module
variable "eks_service_role_name" {
  type = string    
}
variable "iam_minimum_policy_name" {
  type = string    
}
variable "service_role_policy" {
  type = string    
}
variable "vpc_role_policy" {
  type = string    
}
variable "rancher_eks_user_access_key" {
  type = string  
}
variable "rancher_eks_user_secret_key" {
  type = string
}
variable "additional_iam_policies" {
  type = list
  default = []
}


// EKS Cluster
variable "clusters" {
  type = list
  default = []
}
variable "ec2_remote_ssh_public_key" {
  type = string
}
variable "rancher2_aws_credential" {
  type = string
}
variable "eks_non_lt_node_group" {
  type = list
  default = []
}
variable "eks_cluster_non_lt_name" {
  type = string
}
variable "asg_subnet" {
  type = list
  default = []
}
variable "asg_tags" {
  type = map
  default = {}
}

variable "rancher2_cluster_depends_on" {
  # the value doesn't matter; we're just using this variable
  # to propagate dependencies.
  type    = any
  default = []
}


// cluster
variable "aws_ami_name" {
  type = string    
}
variable "aws_instance_profile" {
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
variable "aws_region" {
  type = string    
}
variable "aws_account_name" {
  type    = string  
}
variable "aws_account_number" {
  type    = string
 
}
variable "aws_ec2_key_name" {
  type = string    
}



