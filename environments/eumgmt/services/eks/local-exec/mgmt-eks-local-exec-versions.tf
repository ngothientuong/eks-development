########################################################
# versions
########################################################

terraform {
  required_version = ">= 1.3.1"

  # cannot use variables so initialize backend with separate hcl file - 
  # terraform init -backend-config=env/challenge.hcl
  backend "s3" {
    key = "global/tngo/environments/mgmt/services/eks/local_exec/terraform.tfstate"
    #key = "${format("%s/%s",var.user_state,"/environments/mgmt/infrastructure/terraform.tfstate")}"
  }

  required_providers {

    template = {
      source  = "hashicorp/template"
      version = ">=2.2.0"
    }

    null = {
      source  = "hashicorp/null"
      version = ">=3.1.1"
    }

    local = {
      source = "hashicorp/local"
      version = ">=2.4.0"
    }
  }
}