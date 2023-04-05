########################################################
# versions
########################################################

terraform {
  required_version = ">= 1.3.1"

  # cannot use variables so initialize backend with separate hcl file - 
  # terraform init -backend-config=env/challenge.hcl
  backend "s3" {
    key = "global/tngo/environments/mgmt/services/eks/addon/kube2iam/terraform.tfstate"    
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      #version = ">= 3.72.0"
      version = ">= 4.37.0"
    }
    template = {
      source  = "hashicorp/template"
      version = ">=2.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.18.1"
      configuration_aliases = [  kubernetes.project-mgmt-eks-cluster-rancher-test , kubernetes.project-mgmt-eks-cluster-int-test  ]
    }       
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9.0"
      configuration_aliases = [  helm.project-mgmt-eks-cluster-rancher-test , helm.project-mgmt-eks-cluster-int-test  ]
    }    
    null = {
      source  = "hashicorp/null"
      version = ">=3.1.1"
    }
  }
}