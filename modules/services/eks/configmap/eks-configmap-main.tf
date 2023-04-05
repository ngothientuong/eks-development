########################################################
# providers
########################################################
terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

resource "kubernetes_config_map" "aws_auth" {  

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
    labels = merge(
      {
        "app.kubernetes.io/managed-by" = "terraform-aws-eks-blueprints"
        "app.kubernetes.io/created-by" = "terraform-aws-eks-blueprints"
      },
      var.aws-auth_context.aws_auth_additional_labels
    )
  }

  data = {
    mapRoles = var.aws-auth_context.mapRoles
    mapUsers    = var.aws-auth_context.mapUsers
    mapAccounts = var.aws-auth_context.mapAccounts
  }  
}



