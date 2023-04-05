# Variable for the resources
variable "aws_region" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "vpc_id" {}
variable "private_subnets" {}
variable "rancher_admin_url" {}
variable "rancher_admin_token" {}
variable "create_rancher_config" {}
variable "rancher2_aws_credential" {}
variable "asg_subnet" {}
variable "asg_tags" {}
variable "rancher_eks_user_access_key" {}
variable "rancher_eks_user_secret_key" {}
variable "rancher2_cluster_depends_on" {}
variable "ec2_remote_ssh_public_key" {}
variable "clusters" {
  type = list(object({
    cluster_name                            = string
    vpc_id                                  = optional(string)
    description                             = optional(string)
    enable_network_policy                   = optional(string)
    default_pod_security_policy_template_id = optional(string)
    enable_cluster_monitoring               = optional(bool)
    cluster_monitoring_input                = optional(list(map(string)))
    cloud_credential_id                     = optional(string)
    k8s_kms_key_id                          = optional(string)
    secrets_encryption                      = optional(bool)
    region                                  = optional(string)
    eks_version                             = optional(string)
    logging_types                           = optional(list(string))
    eks_subnets                             = optional(list(string))
    eks_security_groups                     = optional(list(string))
    private_access                          = optional(bool)
    public_access                           = optional(bool)
    service_role                            = optional(string)
    launch_template                         = optional(object({
        block_device_mappings = optional(list(object({
            device_name = optional(string)
            ebs = optional(object({
                delete_on_termination = optional(string)
                volume_size = optional(number)
                volume_type = optional(string)
            }))
        })))
        default_version = optional(number)
        disable_api_stop = optional(bool)
        disable_api_termination = optional(bool)
        ebs_optimized = optional(bool)
    }))
    node_groups = list(object({
      name          = string
      instance_type = optional(string)
      desired_size  = optional(number)
      max_size      = optional(number)
      disk_size     = optional(number)
      subnets       = optional(list(string))
      ec2_ssh_key   = optional(string)
      labels        = optional(map(string))
      tags          = optional(map(string))
      user_data     = optional(string)
    }))
  }))
}