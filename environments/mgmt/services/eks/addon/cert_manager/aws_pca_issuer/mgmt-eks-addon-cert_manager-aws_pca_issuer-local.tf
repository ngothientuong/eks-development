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
  # Format of helm_info:  [[{},{}...{}],[{},{}...{}]]
  # where helm_info[0] is the LIST of different helms of 1st cluster
  # and helm[0][0] is the first helm chart deployed in the 1st cluster
  # and helm[0][1] is the first helm chart deployed in 1st cluster
  helm_info = [
    # List of helm in cluster 0
    [{
      cluster_name = var.clusters[0].cluster_name
      # Name - Name is the name of the release
      name = "aws-pca-issuer"
      repository = "https://cert-manager.github.io/aws-privateca-issuer"
      chart = "aws-pca-issuer"      
      # Chart version
      version = ""
      #values = []     
      values = [
        templatefile("${path.module}/../../helm/values/cert_manager.tpl.yaml", {
          sa_iam_role = format("%q",element([ for vl in data.terraform_remote_state.cluster.outputs.openid_connect_sa_role_objs: vl.arn if length(regexall(var.clusters[0].cluster_name,vl.id)) > 0],0))
        }),
        templatefile("${path.module}/../../helm/values/aws_pca_issuer.tpl.yaml", {})
      ]
      # Set to true if you do NOT want to install crds
      skip_crds = false
      namespace = "aws-pca-issuer"
      create_namespace = true    
      force_update = true
      recreate_pods = true
      timeout = 300
      verify = false # If true then requires /home/vagrant/.gnupg/pubring.gpg which is not found
      set = [
        # {
        #   name = "serviceAccount\\.name"
        #   value = "aws-pca-issuer"
        # },
        # ## Below doesn't work because the default value template commented out serviceAccount.annotations 
        # {
        #   name = "serviceAccount\\.annotations\\.eks\\.amazonaws\\.com/role-arn"
        #   value = format("%q",element([ for vl in data.terraform_remote_state.cluster.outputs.openid_connect_sa_role_objs: vl.arn if length(regexall(var.clusters[0].cluster_name,vl.id)) > 0],0))
        # }        
      ]
    }], # } is End of the first helm chart ] is End of the list of helm chart of the first cluster
    [{
      cluster_name = var.clusters[1].cluster_name
      # Name - Name is the name of the release
      name = "aws-pca-issuer"
      repository = "https://cert-manager.github.io/aws-privateca-issuer"
      chart = "aws-pca-issuer"      
      # Chart version
      version = ""
      #values = []     
      values = [
        templatefile("${path.module}/../../helm/values/cert_manager.tpl.yaml", {
          sa_iam_role = format("%q",element([ for vl in data.terraform_remote_state.cluster.outputs.openid_connect_sa_role_objs: vl.arn if length(regexall(var.clusters[1].cluster_name,vl.id)) > 0],0))
        }),
        templatefile("${path.module}/../../helm/values/aws_pca_issuer.tpl.yaml", {})
      ]
      # Set to true if you do NOT want to install crds
      skip_crds = false
      namespace = "aws-pca-issuer"
      create_namespace = true    
      force_update = true
      recreate_pods = true
      timeout = 300
      verify = false # If true then requires /home/vagrant/.gnupg/pubring.gpg which is not found
      set = [
        # {
        #   name = "serviceAccount.name"
        #   value = "aws-pca-issuer"
        # },
        ## Below doesn't work because the default value template commented out serviceAccount.annotations 
        # {
        #   name = "serviceAccount.annotations\\.eks\\.amazonaws\\.com/role-arn"          
        #   value = format("%q",element([ for vl in data.terraform_remote_state.cluster.outputs.openid_connect_sa_role_objs: vl.arn if length(regexall(var.clusters[1].cluster_name,vl.id)) > 0],0))
        #   type = "string"
        # }
        
      ]
    }] # End of the list of the last cluster
  ]
}









