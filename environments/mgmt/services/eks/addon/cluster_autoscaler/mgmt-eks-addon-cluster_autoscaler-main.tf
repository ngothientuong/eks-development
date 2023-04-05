#################
# Data sources  #
#################
## VPC
data "aws_availability_zones" "available" {}

# Get the caller ID
data "aws_caller_identity" "current" {}

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

data "terraform_remote_state" "clusters" {
  backend = "s3"
  config = {
        bucket = "${var.s3_bucket_name}"
        key = "global/tngo/environments/mgmt/services/eks/cluster/terraform.tfstate"
  }
}

locals {
    tags = {
        Group = "${var.env}"
        Name = "${format("%s%s%s",var.project_id,"-",var.env)}"
        Project = "${var.project_name}"
        VPC = "${format("%s%s%s",var.project_id,"-",var.env)}"
    }     
    vpc_id = data.aws_vpc.vpc_main.id
    private_subnet_ids = data.aws_subnets.private.ids
    image_version = "v1.25.0"
    service_account_role_arns = data.terraform_remote_state.clusters.outputs.openid_connect_sa_role_objs
}
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key  
}

module "cluster_autoscaler_creation" {
  source = "../../../../../../modules/services/eks/addon/cluster_autoscaler"      
  aws_region = "${var.aws_region}"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"  
  aws_caller_identity = data.aws_caller_identity.current.id
  image_version = local.image_version
  clusters = var.clusters
  service_account_role_arns = local.service_account_role_arns
}