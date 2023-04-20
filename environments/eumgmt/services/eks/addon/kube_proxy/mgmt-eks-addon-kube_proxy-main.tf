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
    clusters = var.clusters  
    service_account_role_arns = data.terraform_remote_state.clusters.outputs.openid_connect_sa_role_objs
    # Get image version by running: kubectl describe daemonset kube-proxy -n kube-system | grep Image
    # Replace region code if needed as well as image version: https://docs.aws.amazon.com/eks/latest/userguide/managing-kube-proxy.html
    image_version = "602401143452.dkr.ecr.us-east-2.amazonaws.com/eks/kube-proxy:v1.25.6-minimal-eksbuild.2"
    #addon_version = "v1.25.6-eksbuild.2"
    
}


provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key  
}

module "kube_proxy_addon" {
  source = "../../../../../../modules/services/eks/addon/kube_proxy"
  aws_region = "${var.aws_region}"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"  
  clusters = local.clusters    
  service_account_role_arns = local.service_account_role_arns
  image_version = local.image_version  
  aws_caller_identity = data.aws_caller_identity.current.id
}
