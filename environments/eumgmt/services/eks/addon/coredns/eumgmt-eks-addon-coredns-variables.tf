################################
# Variable for the resources   #
################################
variable "env" {
  type = string    
}
variable "env_lc" {
  type = string    
}

// EKS Cluster
variable "clusters" {
  type = list
  default = []
}
variable "service_account_role_arns" {
  type = list
  default = []
}

# variable "iam_role_path" {
#   type = string
# }

variable "aws_ec2_key_name" {
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





