########################################################
# versions
########################################################

terraform {
  required_version = ">= 1.3.1"

  # cannot use variables so initialize backend with separate hcl file - 
  # terraform init -backend-config=env/challenge.hcl
  backend "s3" {
    key = "global/tngo/environments/mgmt/infrastructure/terraform.tfstate"
    #key = "${format("%s/%s",var.user_state,"/environments/mgmt/infrastructure/terraform.tfstate")}"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.35.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }
  }
}