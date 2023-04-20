########################################################
# versions
########################################################

terraform {
  required_version = ">= 1.3.1"

  # cannot use variables so initialize backend with separate hcl file - 
  # terraform init -backend-config=env/challenge.hcl
  backend "s3" {
    key = "global/tngo/environments/mgmt/services/eks/addon/velero/s3_backup/terraform.tfstate"    
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      #version = ">= 3.72.0"
      version = ">= 4.37.0"
    }
  }
}