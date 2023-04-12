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

data "aws_subnets" "private_subnets" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
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
    pre_template_kubectl_commands = [
      {
        pre_template_kubectl_command = <<EOF
          echo "${templatefile("${path.module}/../../../../../../modules/services/eks/addon/generic_kubectl/manifests/ext_snapshotter/cert.yaml", {cluster_name = var.clusters[0].cluster_name})}" > "${path.module}/../../../../../../modules/services/eks/addon/generic_kubectl/manifests/ext_snapshotter/rendered/cert.yaml"
          kubectl replace --grace-period 0 --force -f "${path.module}/../../../../../../modules/services/eks/addon/generic_kubectl/manifests/ext_snapshotter/rendered/cert.yaml"
          sleep 2          
          kubectl get secret snapshot-validation-secret -n kube-system -o=jsonpath={.data.ca\\.crt} > ~/ca_base64.crt          
        EOF
      },    
      {
        pre_template_kubectl_command = <<EOF
          echo "${templatefile("${path.module}/../../../../../../modules/services/eks/addon/generic_kubectl/manifests/ext_snapshotter/cert.yaml", {cluster_name = var.clusters[1].cluster_name})}" > "${path.module}/../../../../../../modules/services/eks/addon/generic_kubectl/manifests/ext_snapshotter/rendered/cert.yaml"
          kubectl replace --grace-period 0 --force -f "${path.module}/../../../../../../modules/services/eks/addon/generic_kubectl/manifests/ext_snapshotter/rendered/cert.yaml"
          sleep 2          
          kubectl get secret snapshot-validation-secret -n kube-system -o=jsonpath={.data.ca\\.crt} > ~/ca_base64.crt
        EOF        
      },
      {
        pre_template_kubectl_command = <<EOF
          echo "${templatefile("${path.module}/../../../../../../modules/services/eks/addon/generic_kubectl/manifests/ext_snapshotter/cert.yaml", {cluster_name = var.clusters[2].cluster_name})}" > "${path.module}/../../../../../../modules/services/eks/addon/generic_kubectl/manifests/ext_snapshotter/rendered/cert.yaml"
          kubectl replace --grace-period 0 --force -f "${path.module}/../../../../../../modules/services/eks/addon/generic_kubectl/manifests/ext_snapshotter/rendered/cert.yaml"
          sleep 2          
          kubectl get secret snapshot-validation-secret -n kube-system -o=jsonpath={.data.ca\\.crt} > ~/ca_base64.crt
        EOF        
      }
    ]
    post_template_kubectl_commands = [
      {
        post_template_kubectl_command = <<EOF
          echo # Has to have something here or else bash failed          
          python ./replace_var.py
          kubectl replace --grace-period 0 --force -f "${path.module}/../../../../../../modules/services/eks/addon/generic_kubectl/manifests/ext_snapshotter/rendered/admission-configuration.yaml"
          echo After kubectl replace
        EOF
      },    
      {
        post_template_kubectl_command = <<EOF
          python ./replace_var.py          
          kubectl replace --grace-period 0 --force -f "${path.module}/../../../../../../modules/services/eks/addon/generic_kubectl/manifests/ext_snapshotter/rendered/admission-configuration.yaml"
          echo After kubectl replace
        EOF        
      },
      {
        post_template_kubectl_command = <<EOF
          python ./replace_var.py          
          kubectl replace --grace-period 0 --force -f "${path.module}/../../../../../../modules/services/eks/addon/generic_kubectl/manifests/ext_snapshotter/rendered/admission-configuration.yaml"
          echo After kubectl replace
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
    sub_path = "ext_snapshotter"

}
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key  
}
