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

# Add new cluster if not exists
# Change context to the correct cluster
# Perform kubectl operation
resource "null_resource" "kube_proxy_upgrade" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  triggers = {
    always_run = "${timestamp()}"
  }
  ## Syntax: python <pyscript> <clustername> <endpoint> <cluster_ca_certificate> <env> <count.index> <total run>
  provisioner "local-exec" {        
    command = <<-EOT
      # Remove Cluster contexts in kubectl      
      if [ "$(kubectl config get-contexts | grep  ${var.clusters[count.index].cluster_name}  )" != '' ]  
      then         
        kubectl config delete-cluster arn:aws:eks:${var.aws_region}:${var.aws_caller_identity}:cluster/${var.clusters[count.index].cluster_name}
        kubectl config unset users.arn:aws:eks:${var.aws_region}:${var.aws_caller_identity}:cluster/${var.clusters[count.index].cluster_name} 
        kubectl config delete-context arn:aws:eks:${var.aws_region}:${var.aws_caller_identity}:cluster/${var.clusters[count.index].cluster_name} 
      fi      
      # Replace null character with empty list
      if [ -f ~/.kube/config ]
      then
        sed -i 's/null/\[\]/g' ~/.kube/config
        if [ "$(tail -n 2 ~/.kube/config | grep 'command')" != "" ]
        then
          rm -rf ~/.kube/config
        fi
      fi
      # Readd cluster context in kubectl                  
      #aws eks update-kubeconfig --region ${var.aws_region} --name ${var.clusters[count.index].cluster_name}            
      if [ "$(kubectl config get-contexts | grep  ${var.clusters[count.index].cluster_name}  )" == '' ] ; then aws eks update-kubeconfig --region ${var.aws_region} --name ${var.clusters[count.index].cluster_name} ; fi      
      kubectl config use-context arn:aws:eks:${var.aws_region}:${var.aws_caller_identity}:cluster/${var.clusters[count.index].cluster_name}      
      kubectl set image daemonset.apps/kube-proxy -n kube-system kube-proxy=${var.image_version}
      kubectl describe daemonset kube-proxy -n kube-system | grep Image | cut -d ":" -f 3
    EOT    
    }
}


# ## Add additional tags for subnets for k8s auto discovery
# ## The below resource is only for self-managed kube-proxy addon
# ## For Debian-based docker image
# resource "aws_eks_addon" "kube_proxy" {  
#   count = length(var.clusters) > 0 ? length(var.clusters) : 0
#   cluster_name = var.clusters[count.index].cluster_name
#   service_account_role_arn = var.service_account_role_arns[count.index].arn
#   addon_name   = "kube_proxy"
#   addon_version =  var.addon_version
#   resolve_conflicts = "OVERWRITE" # Only used during upgrade, not creation
# }