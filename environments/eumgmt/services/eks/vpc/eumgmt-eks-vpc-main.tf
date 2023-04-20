#################
# Data sources  #
#################
## VPC
data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

## Rancher datasources


data "aws_vpc" "vpc_main" {    
  tags = {
    ## MHV 
    #Environment = var.env
    #ProjectName = var.project_name 
        ## By Light
    Group = var.env
    Name  = "${format("%s%s%s",var.project_id,"-",var.env)}"
  }

}

data "aws_subnets" "private" {
    filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc_main.id]
  }
  
  tags = {
    #Name = "${format("%s%s%s","MHV:",var.env,"*App:Private")}"
    Name = "${format("%s%s%s%s",var.project_id,"-",var.env,"-private-subnet-*")}"
  }
}

locals {
    tags = {
        Group = "${var.env}"
        Name = "${format("%s%s%s",var.project_id,"-",var.env)}"
        Project = "${var.project_name}"
        VPC = "${format("%s%s%s",var.project_id,"-",var.env)}"
    }     
    # VPC
    vpc_id = data.aws_vpc.vpc_main.id
    #private_subnet_ids = data.aws_subnets.private.ids
    #private_subnet_ids = []  
    # Tags all subnets identified in the cluster
    cluster_subnets = distinct(flatten([
      for each_cluster in var.clusters: [
        for each_subnet in each_cluster.eks_subnets: {
          subnet_id = each_subnet
          cluster_name = each_cluster.cluster_name
        }
    ]]))
    
}

module "eks_vpc_additional_subnet_tags" {
  source = "../../../../../modules/services/eks/vpc/subnet_tags"
  aws_region = "${var.aws_region}"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"      
  aws_subnets_ids = local.cluster_subnets
}


















# # Create Rancher Admin configuration
# module "rancher_admin_config" {
#   source = "../../../../modules/services/rancher/bootstrap"
#   #count = var.create_rancher_config ? 1 : 0

#   create_rancher_config = "${var.create_rancher_config}"
#   rancher_initial_password = "${var.rancher_initial_password}"
#   rancher_url = local.rancher_url
#   rancher_password = data.aws_ssm_parameter.rancher_password.value
# }

# # Create IAM roles --- Only Use once and separated from rancher install
# module "iam_role_policy_creation" {
#   source = "../../../../modules/services/rancher/iam"
#   #count = var.create_rancher_config ? 1 : 0

#   aws_region = "${var.aws_region}"
#   aws_access_key = "${var.aws_access_key}"
#   aws_secret_key = "${var.aws_secret_key}"
#   #create_rancher_config = false  # Remove this resource for now
#   create_rancher_config = "${var.create_rancher_config}"
#   # Create new service role with mimimum permission
#   eks_service_role_name = "${var.eks_service_role_name}"
#   iam_minimum_policy_name = "${var.iam_minimum_policy_name}"
#   service_role_policy = "${var.service_role_policy}"
#   vpc_role_policy = "${var.vpc_role_policy}"  
#   additional_iam_policies = "${var.additional_iam_policies}"
# }

# # Create EKS cluster
# module "eks_cluster_creation" {
#   source = "../../../../modules/services/rancher/eks_cluster_non_lt"
  
#   create_rancher_config = "${var.create_rancher_config}"
  
  
#   // Providers
#   rancher_admin_url = tolist([module.rancher_admin_config.rancher2_bootstrap_admin_url])[0]
#   rancher_admin_token = tolist([module.rancher_admin_config.rancher2_bootstrap_admin_token])[0]
#   aws_region = "${var.aws_region}"
#   aws_access_key = "${var.aws_access_key}"
#   aws_secret_key = "${var.aws_secret_key}"  


#   rancher2_aws_credential = "${var.rancher2_aws_credential}"
#   rancher_eks_user_access_key = "${var.rancher_eks_user_access_key}"
#   rancher_eks_user_secret_key = "${var.rancher_eks_user_secret_key}"

#   ec2_remote_ssh_public_key = "${var.ec2_remote_ssh_public_key}"
#   clusters = "${var.clusters}"
#   asg_subnet = "${local.private_subnet_ids}"
#   asg_tags = "${local.tags}"

#   rancher2_cluster_depends_on = [module.rancher_admin_config,module.iam_role_policy_creation]
#   vpc_id = local.vpc_cidr
#   private_subnets = local.private_subnets
    
# }