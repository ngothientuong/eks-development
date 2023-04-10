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

data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
        bucket = "${var.s3_bucket_name}"
        key = "global/tngo/environments/mgmt/services/eks/cluster/terraform.tfstate"
  }
}

data "terraform_remote_state" "aws_security_group" {
  backend = "s3"
  config = {
        bucket = "${var.s3_bucket_name}"
        key = "global/tngo/environments/mgmt/services/eks/sg/terraform.tfstate"
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
    # Populate managed node group data
    managed_ng_contexts = distinct(flatten([
      for each_cluster in var.clusters: [
        for each_mn_ng in each_cluster.node_groups: {
          cluster_name = each_cluster.cluster_name
          version = each_mn_ng.ng_eks_version  # Make node group version the same version as the control plane
          node_role_arn = data.terraform_remote_state.iam-roles.outputs.ng_role_arn
          subnet_ids = each_cluster.eks_subnets  # Option1: User same subnet as the cluster for managed node groups          
          ng_subnet_ids = each_mn_ng.ng_subnets  # Option 2: Use dedicated subnet ID for each node group
          desired_size = each_mn_ng.desired_size
          max_size = each_mn_ng.max_size
          min_size = each_mn_ng.min_size
          #disk_size = each_mn_ng.disk_size # Replaced volumes in LT
          #max_unavailable = each_mn_ng.max_unavailable  # Only 1 available. Either max nodes or maxed percentage
          max_unavailable_percentage = each_mn_ng.max_unavailable_percentage
          # ami_type = each_mn_ng.ami_type # Avoid while using LT                    
          capacity_type = each_mn_ng.capacity_type
          force_update_version = each_mn_ng.force_update_version
          # instance_types = each_mn_ng.instance_types # In LT section
          labels = merge(each_mn_ng.labels,{
            "disk_size" = format("%q",element([ for ds in each_mn_ng.lt_config.block_device_mappings: ds.volume_size if ds.device_name == "/dev/xvda"],0))
            "eks_cluster_id" = each_cluster.cluster_name
            "instance_type" = each_mn_ng.lt_config.instance_type
            "desired_size" = each_mn_ng.desired_size
            "max_size"  =  each_mn_ng.max_size
            "eks_version" = each_mn_ng.ng_eks_version            
          })
          node_group_name_prefix = each_mn_ng.node_group_name_prefix # Conflict with node_group_name
          #release_version = each_mn_ng.release_version # Avoid this for now so EKS can push out the latest release for you
          #ec2_ssh_key = each_mn_ng.ec2_ssh_key # Replaced by key_name in LT
          tags = merge(each_mn_ng.lt_config.tag_specifications.tags,{
            "${format("%s%s","k8s.io/cluster-autoscaler/",each_cluster.cluster_name)}" = "owned"
            #"${format("%s%s","k8s.io/cluster/",each_cluster.cluster_name)}" = "shared"  # This tag is required for the subnets by AWS Load Balancer Controller version 2.1.1 or earlier
            "k8s.io/cluster-autoscaler/enabled" = true
            Name = each_mn_ng.node_group_name_prefix
          })    # LT - This is for k8-auto scaler
          taint = flatten(concat(each_mn_ng.taint , [{}]))

          ## Section for launch template
          ## User data parameters
          pre_userdata = each_mn_ng.pre_userdata
          post_userdata = each_mn_ng.post_userdata
          eks_cluster_id = each_cluster.cluster_name
          cluster_ca_base64 = format("%q",element([ for vl in data.terraform_remote_state.cluster.outputs.clusters_obj: vl.certificate_authority[0].data if vl.id == each_cluster.cluster_name],0))
          cluster_endpoint = format("%q",element([ for vl in data.terraform_remote_state.cluster.outputs.clusters_obj: vl.endpoint if vl.id == each_cluster.cluster_name],0))
          service_ipv4_cidr = format("%q",element([ for vl in data.terraform_remote_state.cluster.outputs.clusters_obj: vl.kubernetes_network_config[0].service_ipv4_cidr if vl.id == each_cluster.cluster_name],0))
          service_ipv6_cidr = format("%q",element([ for vl in data.terraform_remote_state.cluster.outputs.clusters_obj: vl.kubernetes_network_config[0].service_ipv6_cidr if vl.id == each_cluster.cluster_name],0))          
          kubelet_extra_args = each_mn_ng.kubelet_extra_args   
          bootstrap_extra_args = each_mn_ng.bootstrap_extra_args
          kms_key_id = data.terraform_remote_state.cluster-kms.outputs.ksm_arn          
          lt_config = each_mn_ng.lt_config          
          eks_security_group_id = format("%q",element([ for sg in data.terraform_remote_state.aws_security_group.outputs.eks_sg_default: sg.id if length(regexall(each_cluster.cluster_name, sg.name)) > 0],0))
          s3_artifact = var.project_archive
          project_id = var.project_id
          aws_region = var.aws_region
          ### Look into placement block { availability_zone = "us-east-2a" } in LT
          cluster_security_group_id = format("%q",element([ for cluster_sg_id in data.terraform_remote_state.cluster.outputs.clusters_obj: cluster_sg_id.vpc_config[0].cluster_security_group_id if cluster_sg_id.name == each_cluster.cluster_name],0))

        }
    ]])) 
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


# Create EKS cluster 
module "eks_mn_ng_creation" {
  source = "../../../../../modules/services/eks/eks-managed_ng"

  aws_region = "${var.aws_region}"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"  
  managed_ng_contexts = local.managed_ng_contexts
  #cluster_role_arn = "${data.terraform_remote_state.iam-roles.outputs.cluster_role_arn}"
  #clusters = "${var.clusters}"  
  k8s_kms_key_arn = "${data.terraform_remote_state.cluster-kms.outputs.ksm_arn}"  
  #iam_role_path = "${var.iam_role_path}"
  #permissions_boundary = "${var.permissions_boundary}"  
  #clusters_obj = "${data.terraform_remote_state.cluster.outputs.clusters_obj}"

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