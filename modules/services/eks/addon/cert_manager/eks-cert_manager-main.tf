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
    kubernetes = {
      source = "hashicorp/kubernetes"
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

resource "null_resource" "set_initial_state" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "echo \"0\" > ~/counter; sleep 5"
  }
}

# Add new cluster if not exists
# Change context to the correct cluster
# Perform kubectl operation
resource "null_resource" "cert_manager_prereq_custom_crd" {  
  triggers = {
    always_run = "${timestamp()}"
  }
  ## Syntax: python <pyscript> <clustername> <endpoint> <cluster_ca_certificate> <env> <count.index> <total run>
  provisioner "local-exec" {        
    command = <<-EOT
      # Give a few second for 1 loop to finish before the next            
      while [[ $(cat ~/counter) != $(echo ${tonumber(var.count_idx)}) ]]
      do
        echo "Waiting on Job index ${tonumber(var.count_idx) - 1}"             
        sleep 2
      done   


        # Remove Cluster contexts in kubectl      
        if [ "$(kubectl config get-contexts | grep  ${var.clusters[tonumber(var.count_idx)].cluster_name}  )" != '' ]  
        then         
          kubectl config delete-cluster arn:aws:eks:${var.aws_region}:${var.aws_caller_identity}:cluster/${var.clusters[tonumber(var.count_idx)].cluster_name}
          kubectl config unset users.arn:aws:eks:${var.aws_region}:${var.aws_caller_identity}:cluster/${var.clusters[tonumber(var.count_idx)].cluster_name} 
          kubectl config delete-context arn:aws:eks:${var.aws_region}:${var.aws_caller_identity}:cluster/${var.clusters[tonumber(var.count_idx)].cluster_name} 
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
        if [ "$(kubectl config get-contexts | grep  ${var.clusters[tonumber(var.count_idx)].cluster_name}  )" == '' ] ; then aws eks update-kubeconfig --region ${var.aws_region} --name ${var.clusters[tonumber(var.count_idx)].cluster_name} ; fi      
        ## Run kubectl for multiple yaml.tpl files  
        helm repo remove jetstack https://charts.jetstack.io
        helm repo update 
        kubectl delete ns security
        kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.crds.yaml --force --grace-period 0 2>&1 &
        kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml --force --grace-period 0 2>&1 &
        sleep 10                 


      echo "Job ${tonumber(var.count_idx)} completed"  
      ## Allow the next loop to go
      echo ${tonumber(var.count_idx) + 1} > ~/counter      
    EOT    
    }
  depends_on = [ null_resource.set_initial_state ]
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