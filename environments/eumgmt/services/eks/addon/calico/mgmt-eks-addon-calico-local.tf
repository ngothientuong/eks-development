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
## The below tfm remote state 'cluster' is for helm
data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
        bucket = "${var.s3_bucket_name}"
        key = "global/tngo/environments/mgmt/services/eks/cluster/terraform.tfstate"
  }
}
####################
### Generic Run  ###
####################
# Duplication but for generic_kubectl
data "terraform_remote_state" "clusters" {
  backend = "s3"
  config = {
        bucket = "${var.s3_bucket_name}"
        key = "global/tngo/environments/mgmt/services/eks/cluster/terraform.tfstate"
  }
}
data "aws_vpc" "clusters_vpc" {    
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  tags = {
    ## MHV 
    #Environment = var.env
    #ProjectName = var.project_name 
        ## By Light
    Group = var.clusters[count.index].cluster_env
    Name  = "${format("%s%s%s",var.project_id,"-",var.clusters[count.index].cluster_env)}"
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
      name = "calico"
      repository = "https://docs.tigera.io/calico/charts"
      chart = "tigera-operator"      
      # Chart version
      version = ""
      #values = []     
      values = [
        templatefile("${path.module}/../helm/values/calico.tpl.yaml", {
          sa_iam_role = format("%q",element([ for vl in data.terraform_remote_state.cluster.outputs.openid_connect_sa_role_objs: vl.arn if length(regexall(var.clusters[0].cluster_name,vl.id)) > 0],0)),          
          region = var.aws_region,
          aws_access_key_id = var.aws_access_key,
          aws_secret_access_key = var.aws_secret_key,
          cluster_name = var.clusters[0].cluster_name,

        }),
        #templatefile("${path.module}/../../helm/values/aws_pca_issuer.tpl.yaml", {})
      ]
      # Set to true if you do NOT want to install crds
      skip_crds = false
      namespace = "tigera-operator"
      create_namespace = true    
      force_update = true
      recreate_pods = true
      timeout = 300
      verify = false # If true then requires /home/vagrant/.gnupg/pubring.gpg which is not found
      set = [
        {
          name = "serviceAccount.name"
          value = "tigera-operator"
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
        # {
        #   name = "credentials.secretContents.cloud"
        #   value = "~/.velero"
        # },       
      ]      
    }], # } is End of the first helm chart ] is End of the list of helm chart of the first cluster
    [{
      cluster_name = var.clusters[1].cluster_name
      # Name - Name is the name of the release
      name = "calico"
      repository = "https://docs.tigera.io/calico/charts"
      chart = "tigera-operator"      
      # Chart version
      version = ""
      #values = []     
      values = [
        templatefile("${path.module}/../helm/values/calico.tpl.yaml", {
          sa_iam_role = element([ for vl in data.terraform_remote_state.cluster.outputs.openid_connect_sa_role_objs: vl.arn if length(regexall(var.clusters[1].cluster_name,vl.id)) > 0],0)
          region = var.aws_region,
          aws_access_key_id = var.aws_access_key,
          aws_secret_access_key = var.aws_secret_key,
          cluster_name = var.clusters[1].cluster_name,

        }),
        #templatefile("${path.module}/../../helm/values/aws_pca_issuer.tpl.yaml", {})
      ]
      # Set to true if you do NOT want to install crds
      skip_crds = false
      namespace = "tigera-operator"
      create_namespace = true    
      force_update = true
      recreate_pods = true
      timeout = 300
      verify = false # If true then requires /home/vagrant/.gnupg/pubring.gpg which is not found
      set = [
        {
          name = "serviceAccount.name"
          value = "tigera-operator"
        },
        ## Below doesn't work because the default value template commented out serviceAccount.annotations 
        {
          name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"          
          value = element([ for vl in data.terraform_remote_state.cluster.outputs.openid_connect_sa_role_objs: vl.arn if length(regexall(var.clusters[1].cluster_name,vl.id)) > 0],0)
          # type = "string"  # Remove this because it gives unwanted quote
        },
        {
          name = "clusterName"
          value = var.clusters[1].cluster_name
        },      
        # {
        #   name = "credentials.secretContents.cloud"
        #   value = "~/.velero"
        # },     
      ]
    }] # End of the list of the last cluster
  ]
  ## Generic run
  pre_template_kubectl_commands = [
      {
        pre_template_kubectl_command = <<EOF
          echo # Must have echo at beginnging to avoid bug                        
        EOF
      },    
      {
        pre_template_kubectl_command = <<EOF
          echo # Must have echo at beginnging to avoid bug
        EOF        
      }
    ]
    post_template_kubectl_commands = [
      {
        post_template_kubectl_command = <<EOF
          echo # Has to have something here or else bash failed          
        EOF
      },    
      {
        post_template_kubectl_command = <<EOF
          echo # Has to have something here or else bash failed  
        EOF        
      }
    ]    
  service_account_role_arns = data.terraform_remote_state.clusters.outputs.openid_connect_sa_role_objs
  service_account_roles = data.terraform_remote_state.clusters.outputs.openid_connect_sa_role_objs
  clusters_info = flatten([
    for count in range(length(var.clusters)):
      merge(var.clusters[tonumber(count)],data.aws_vpc.clusters_vpc[tonumber(count)], local.pre_template_kubectl_commands[tonumber(count)],local.post_template_kubectl_commands[tonumber(count)],local.service_account_roles[tonumber(count)])
  ])
  ## This subpath contains speficif files for the plugins
  sub_path = "calico"
}









