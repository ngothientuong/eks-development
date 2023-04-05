# Variable for the resources

variable "aws_region" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "cluster_role_arn" {}
variable "k8s_kms_key_arn" {}
variable "asg_tags" {}
variable "iam_role_path" {}
variable "permissions_boundary" {}
variable "clusters" {
  # type = list(object({
  #   cluster_name                            = string
  #   cluster_env                             = string
  #   iam_console_user_role                   = string
  #   enabled_cluster_log_types               = optional(list(string))
  #   k8s_kms_key_arn                         = optional(string)    
  #   eks_version                             = optional(string)    
  #   eks_subnets                             = optional(list(string))
  #   eks_security_groups                     = optional(list(string))  
  #   endpoint_private_access                 = optional(bool)
  #   launch_template                         = optional(object({
  #       block_device_mappings = optional(list(object({
  #           device_name = optional(string)
  #           ebs = optional(object({
  #               delete_on_termination = optional(string)
  #               volume_size = optional(number)
  #               volume_type = optional(string)
  #           }))
  #       })))
  #       default_version = optional(number)
  #       disable_api_stop = optional(bool)
  #       disable_api_termination = optional(bool)
  #       ebs_optimized = optional(bool)
  #   }))
  #   node_groups = list(object({
  #     name          = string
  #     instance_type = optional(string)
  #     desired_size  = optional(number)
  #     max_size      = optional(number)
  #     disk_size     = optional(number)
  #     subnets       = optional(list(string))
  #     ec2_ssh_key   = optional(string)
  #     labels        = optional(map(string))
  #     tags          = optional(map(string))
  #     user_data     = optional(string)
  #   }))
  # }))
}