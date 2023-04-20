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

data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
        bucket = "${var.s3_bucket_name}"
        key = "global/tngo/environments/mgmt/services/eks/cluster/terraform.tfstate"
  }
}

provider "aws" {
  #alias = "{{ cluster_name }}"
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
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
    private_subnet_ids = data.aws_subnets.private.ids
    aws-auth_context = distinct(flatten([
      for each_cluster in var.clusters: [{
        #for each_mn_ng in each_cluster: {
        mapRoles = <<EOT
- groups:
  - system:bootstrappers
  - system:nodes
  - system:masters
  rolearn: arn:aws:iam::682331604648:role/project-eks-node-group-ng_role
  username: system:node:{{EC2PrivateDNSName}}
- groups:
  - system:bootstrappers
  - system:nodes
  - system:masters
  rolearn: arn:aws:iam::682331604648:role/project/project-eks-node-group-ng_role
  username: system:node:{{EC2PrivateDNSName}}
- groups:
  - system:bootstrappers
  - system:masters
  rolearn: arn:aws:iam::682331604648:role/adfs-project-administrators
  username: federated-users/Tuong.Ngo
- groups:
  - system:bootstrappers
  - system:masters
  rolearn: arn:aws:iam::682331604648:role/project-eks-cluster-example
  username: tuong-ngo
- groups:
  - system:bootstrappers
  - system:masters
  rolearn: arn:aws:iam::682331604648:role/project-mgmt-rancher-sts_role
  username: tuong-ngo  
  EOT
      mapUsers    = <<EOT
  EOT
      mapAccounts = "682331604648"
      aws_auth_additional_labels = {}    
      }
    ]])) 
    
}









