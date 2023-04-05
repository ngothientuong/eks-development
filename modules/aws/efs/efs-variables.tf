# Variable for the resources



###############################
#  Variables from user.tfvars #
###############################
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


