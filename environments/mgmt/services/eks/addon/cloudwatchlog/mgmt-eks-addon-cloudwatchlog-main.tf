#################
# Data sources  #
#################
## VPC
data "aws_availability_zones" "available" {}

# Get the caller ID
data "aws_caller_identity" "current" {}

## Parameter Stores
// rancher
#data "aws_ssm_parameter" "rancher_username" {
#  name = "/${var.project_id}/rancher/${var.env_lc}/admin/account/username"
#}
#data "aws_ssm_parameter" "rancher_password" {
#  name = "/${var.project_id}/rancher/${var.env_lc}/admin/account/password"
#}
// dockerhub
data "aws_ssm_parameter" "dockerhub_registry_username" {
  name = "/${var.project_id}/dockerhub/registry/proxy/service/account/username"
}
data "aws_ssm_parameter" "dockerhub_registry_password" {
  name = "/${var.project_id}/dockerhub/registry/proxy/service/account/password"
}
// local docker registry
data "aws_ssm_parameter" "docker_registry_username" {
  name = "/${var.project_id}/docker/registry/service/account/username"
}
data "aws_ssm_parameter" "docker_registry_password" {
  name = "/${var.project_id}/docker/registry/service/account/password"
}
// helm catalog
data "aws_ssm_parameter" "helm_catalog_username" {
  name = "/${var.project_id}/helm/catalog/service/account/username"
}
data "aws_ssm_parameter" "helm_catalog_password" {
  name = "/${var.project_id}/helm/catalog/service/account/password"
}
// monitoring
#data "aws_ssm_parameter" "elasticsearch_username" {
#  name = "/${var.project_id}/elasticsearch/service/account/username"
#}
#data "aws_ssm_parameter" "elasticsearch_password" {
#  name = "/${var.project_id}/elasticsearch/service/account/password"
#}

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

data "terraform_remote_state" "iam-roles" {
  backend = "s3"
  config = {
        bucket = "${var.s3_bucket_name}"
        key = "global/tngo/environments/mgmt/services/eks/iam_roles/terraform.tfstate"
  }
}


data "terraform_remote_state" "cluster-kms" {
  backend = "s3"
  config = {
        bucket = "${var.s3_bucket_name}"
        key = "global/tngo/environments/mgmt/services/eks/kms/terraform.tfstate"
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
    #vpc_id = data.aws_vpc.vpc_main[count.index].id
    #azs      = slice(data.aws_availability_zones.available.names, 0, 2)    
    #vpc_cidr = var.project_cidr
    #vpc_cdir_elements = split(".",local.vpc_cidr)  
    #public_subnets = [for myidx in range(length(local.azs)) : join(".",[local.vpc_cdir_elements[0],local.vpc_cdir_elements[1], tostring(tonumber(local.vpc_cdir_elements[2]) + myidx * 2 )  ,replace(local.vpc_cdir_elements[3],"/16","/24" )  ]) ]
    #private_subnets = [for myidx in range(length(local.azs)) : join(".",[local.vpc_cdir_elements[0],local.vpc_cdir_elements[1], tostring(tonumber(local.vpc_cdir_elements[2]) + myidx * 2 + 1 )  ,replace(local.vpc_cdir_elements[3],"/16","/24" )  ]) ]
    vpc_id = data.aws_vpc.vpc_main.id
    private_subnet_ids = data.aws_subnets.private.ids
    // rancher
    #rancher_url = "${format("%s%s%s%s%s%s","https://rancher-ha-",var.project_id,"-",var.env,".",var.project_domain)}"  # https://rancher-ha-tngo-mgmt.bylightsdc.bylight.com 
    // docker hub
    #dockerhub_registry_url = "https://registry-1.docker.io"
    // docker (local)
    #docker_registry_url = "${format("%s%s%s%s%s%s","https://docker-group-",var.project_id,"-",var.env,".",var.project_domain)}"  # "https://docker-group-tngo-mgmt.bylightsdc.bylight.com"
    // helm catalog
    #helm_catalog_url = "${format("%s%s%s%s%s%s%s","https://helm-",var.project_id,"-",var.env,".",var.project_domain,"/repository/helm-local")}"  #  "https://helm-tngo-mgmt.bylightsdc.bylight.com/repository/helm-local"
    // elasticsearch
    #elasticsearch_url = "${format("%s%s%s%s%s%s%s","http://logging-",var.project_id,"-",var.env,".",var.project_domain,":9200")}"   #"http://logging-tngo-mgmt.bylightsdc.bylight.com:9200" #modify to push through LB
    // logstash
    #logstash_url = "${format("%s%s%s%s%s%s%s","http://logging-",var.project_id,"-",var.env,".",var.project_domain,":5400")}" #"http://logging-tngo-mgmt.bylightsdc.bylight.com:5400"
    #rancher_password = data.aws_ssm_parameter.rancher_password.value
}


provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}


resource "aws_cloudwatch_log_group" "example" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0      
  name     = "/aws/eks/${var.clusters[count.index].cluster_name}/cluster"
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  #name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7

  # ... potentially other configuration ...
  skip_destroy = true   # Set to true if you do not wish the log group (and any logs it may contain) to be deleted at destroy time, and instead just remove the log group from the Terraform state.
  #kms_key_id = var.k8s_kms_key_arn  # Wrong permission in the key  
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