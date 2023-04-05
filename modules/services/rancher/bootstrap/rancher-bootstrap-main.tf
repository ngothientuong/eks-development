terraform {
  required_version = ">= 1.3.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.37.0"
    }

    rancher2 = {
      source  = "rancher/rancher2"
      #version = "1.24.1"
      version = "1.25.0"
    }

    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
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
}

provider "rancher2" {
  alias = "bootstrap"

  api_url   = var.rancher_url #https://rancher-ha-c-mgmt.bylightsdc.bylight.com"
  bootstrap = true
  insecure  = true
  timeout     = "3m"
}
# create a new rancher2_bootstrap using bootstrap provider config
resource "rancher2_bootstrap" "admin" {
  count = var.create_rancher_config ? 1 : 0
  provider = rancher2.bootstrap

  initial_password  = var.rancher_password
  password = var.rancher_password        # Must be 12 characters
  
  token_update = true
  telemetry = false

  ### Some people reported issue with the fix below
  # lifecycle {
  #   ignore_changes = [
  #     current_password,
  #   ]
  # }

  #current_password = data.aws_ssm_parameter.rancher_password.value
  #token_update = true
}
# provider config for admin
provider "rancher2" {
  api_url   = rancher2_bootstrap.admin.url
  token_key = rancher2_bootstrap.admin.token
  insecure  = true
}
