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
  #alias = ""
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
      name = "cilium"
      repository = "https://helm.cilium.io/"
      chart = "cilium"      
      # Chart version
      version = ""
      #values = []     
      values = [
        templatefile("${path.module}/../helm/values/sa_annotation.tpl.yaml", {
          sa_iam_role = element([ for vl in data.terraform_remote_state.cluster.outputs.openid_connect_sa_role_objs: vl.arn if length(regexall(var.clusters[0].cluster_name,vl.id)) > 0],0)
        }),
        templatefile("${path.module}/../helm/values/cilium/cluster_0.tpl.yaml", {})
      ]
      # Set to true if you do NOT want to install crds
      skip_crds = false
      namespace = "kube-system"
      create_namespace = false    
      force_update = true
      recreate_pods = true
      timeout = 300
      verify = false # If true then requires /home/vagrant/.gnupg/pubring.gpg which is not found      
      set = [
        {
          name = "serviceAccount.name"
          value = "cilium"
        },
        # ## Below doesn't work because the default value template commented out serviceAccount.annotations 
        {
          name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
          value = element([ for vl in data.terraform_remote_state.cluster.outputs.openid_connect_sa_role_objs: vl.arn if length(regexall(var.clusters[0].cluster_name,vl.id)) > 0],0)
        },
        {
          name = "clusterName"
          value = var.clusters[0].cluster_name
        },
        {
          name = "webhook.hostNetwork"
          value = true
        },
        {
          name = "hostNetwork"
          value = true
        },
        # # Either clusterPoolIPv4PodCIDR or clusterPoolIPv4PodCIDRList is used
        # {
        #   name = "ipam.operator.clusterPoolIPv4PodCIDR"
        #   value = "10.192.0.0/15"    # Disabling the default clusterPoolIPv4PodCIDR: "10.0.0.0/8" to use clusterPoolIPv4PodCIDRList
        # },
        # {
        #   name = "ipam.operator.clusterPoolIPv4PodCIDRList"
        #   value = "10.194.0.0/15"    # 10.192.0.0 -> 10.195.255.254 = 262140 IPs
        #   type = "auto"
        # },
                      
      ]
    }],
    
    # List of helm in cluster 1
    [{
      cluster_name = var.clusters[1].cluster_name
      # Name - Name is the name of the release
      name = "cilium"
      repository = "https://helm.cilium.io/"
      chart = "cilium"      
      # Chart version
      version = ""
      #values = []     
      values = [
        templatefile("${path.module}/../helm/values/sa_annotation.tpl.yaml", {
          sa_iam_role = element([ for vl in data.terraform_remote_state.cluster.outputs.openid_connect_sa_role_objs: vl.arn if length(regexall(var.clusters[1].cluster_name,vl.id)) > 0],0)
        }),
        templatefile("${path.module}/../helm/values/cilium/cluster_1.tpl.yaml", {}),
      ]
      # Set to true if you do NOT want to install crds
      skip_crds = false
      namespace = "kube-system"
      create_namespace = false    
      force_update = true
      recreate_pods = true
      timeout = 300
      verify = false # If true then requires /home/vagrant/.gnupg/pubring.gpg which is not found      
      set = [
        {
          name = "serviceAccount.name"
          value = "cilium"
        },
        # ## Below doesn't work because the default value template commented out serviceAccount.annotations 
        {
          name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
          value = element([ for vl in data.terraform_remote_state.cluster.outputs.openid_connect_sa_role_objs: vl.arn if length(regexall(var.clusters[1].cluster_name,vl.id)) > 0],0)
        },
        {
          name = "clusterName"
          value = var.clusters[1].cluster_name
        },
        {
          name = "webhook.hostNetwork"
          value = true
        },
        {
          name = "hostNetwork"
          value = true
        },   
        # # Either clusterPoolIPv4PodCIDR or clusterPoolIPv4PodCIDRList is used
        # {
        #   name = "ipam.operator.clusterPoolIPv4PodCIDR"
        #   value = "10.200.0.0/15"    # Disabling the default clusterPoolIPv4PodCIDR: "10.0.0.0/8" to use clusterPoolIPv4PodCIDRList
        # },
        # {
        #   name = "ipam.operator.clusterPoolIPv4PodCIDRList"
        #   value = "10.202.0.0/15"    # 10.192.0.0 -> 10.195.255.254 = 262140 IPs
        #   type = "auto"
        # },           
      ]
    }],
    
    # List of helm in cluster 2
    [{
      cluster_name = var.clusters[2].cluster_name
      # Name - Name is the name of the release
      name = "cilium"
      repository = "https://helm.cilium.io/"
      chart = "cilium"      
      # Chart version
      version = ""
      #values = []     
      values = [
        templatefile("${path.module}/../helm/values/sa_annotation.tpl.yaml", {
          sa_iam_role = element([ for vl in data.terraform_remote_state.cluster.outputs.openid_connect_sa_role_objs: vl.arn if length(regexall(var.clusters[2].cluster_name,vl.id)) > 0],0)
        }),
        templatefile("${path.module}/../helm/values/cilium/cluster_2.tpl.yaml", {})
      ]
      # Set to true if you do NOT want to install crds
      skip_crds = false
      namespace = "kube-system"
      create_namespace = false    
      force_update = true
      recreate_pods = true
      timeout = 300
      verify = false # If true then requires /home/vagrant/.gnupg/pubring.gpg which is not found      
      set = [
        {
          name = "serviceAccount.name"
          value = "cilium"
        },
        # ## Below doesn't work because the default value template commented out serviceAccount.annotations 
        {
          name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
          value = element([ for vl in data.terraform_remote_state.cluster.outputs.openid_connect_sa_role_objs: vl.arn if length(regexall(var.clusters[2].cluster_name,vl.id)) > 0],0)
        },
        {
          name = "clusterName"
          value = var.clusters[2].cluster_name
        },
        {
          name = "webhook.hostNetwork"
          value = true
        },
        {
          name = "hostNetwork"
          value = true
        },   
        # # Either clusterPoolIPv4PodCIDR or clusterPoolIPv4PodCIDRList is used
        # {
        #   name = "ipam.operator.clusterPoolIPv4PodCIDR"
        #   value = "10.204.0.0/15"    # Disabling the default clusterPoolIPv4PodCIDR: "10.0.0.0/8" to use clusterPoolIPv4PodCIDRList
        # },
        # {
        #   name = "ipam.operator.clusterPoolIPv4PodCIDRList"
        #   value = "10.206.0.0/15"    # 10.192.0.0 -> 10.195.255.254 = 262140 IPs
        #   #type = "auto"
        # },            
      ]
    }]    
  ]
}