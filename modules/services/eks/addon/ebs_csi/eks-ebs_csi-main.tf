terraform {
  required_version = ">= 1.3.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.37.0"
    }

    template = {
      source  = "hashicorp/template"
      version = ">=2.2.0"
    }

    null = {
      source  = "hashicorp/null"
      version = ">=3.1.1"
    }
  }
}

########################################################
# providers
########################################################

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  ignore_tags {
    key_prefixes = ["kubernetes.io/"]
  }
}

## Add additional tags for subnets for k8s auto discovery
resource "aws_eks_addon" "ebs_csi" {  
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  cluster_name = var.clusters[count.index].cluster_name
  service_account_role_arn = var.service_account_role_arns[count.index].arn
  addon_name   = "aws-ebs-csi-driver"
  addon_version =  var.addon_version
  #addon_version =  "v1.12.5-eksbuild.2"
  resolve_conflicts = "OVERWRITE" # Only used during upgrade, not creation
  # configuration_values = jsonencode({
  #   env = {
  #     # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
  #     ENABLE_PREFIX_DELEGATION = "true"
  #     WARM_PREFIX_TARGET       = "1"
  #   }
  # })
}

# resource "aws_ec2_tag" "eks_cluster_shared" {  
#   count = length(var.aws_subnets_ids) > 0 ? length(var.aws_subnets_ids) : 1
#   resource_id = var.aws_subnets_ids[count.index].subnet_id
#   key         = "${format("%s%s","kubernetes.io/cluster/",var.aws_subnets_ids[count.index].cluster_name)}"
#   value       = "shared"  
# }