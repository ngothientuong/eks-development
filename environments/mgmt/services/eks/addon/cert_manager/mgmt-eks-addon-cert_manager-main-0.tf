data "aws_eks_cluster_auth" "project-mgmt-eks-cluster-rancher-test" {
  name = "project-mgmt-eks-cluster-rancher-test"
}
provider "kubernetes" {  
  alias = "project-mgmt-eks-cluster-rancher-test"
  host                   = "https://9A5969C874B923B781EC8FA1665988EE.gr7.us-east-2.eks.amazonaws.com"
  cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1EUXhOekE0TXpZME0xb1hEVE16TURReE5EQTRNelkwTTFvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBS1EwCldjV1E1cEVhNFBNTE00N1NGQjJkalUxcGtzdEhkQ1RyZDRRTHd6cGZsOWZjbkVzVnpxUXVmOWZQYndFY1dFYW0Ka2dmZkhNbUZjUWpsVFYrUXVmN1RXMmJFdVg3TEZjUFBCZzM4bmpST21vekdCbVBjdVpZc1Rvd0NNSk13UG1QTwpyU2swaThoSzBWb2plMDlxRUdPMTg2RXNCL08vanZpT3dQaDV5R29OTmttTi9sNmFPWE8wM0c5RWFTSFdrUFRPCk5MRmVMbS9yL1FsbEUyTkpYSUdYWVpnYmlSeUZjWVZTZ09MMzBtSHY2U2Z3U3Ntd2ZMQmZjS2hUWnp1TFhJRkUKU241S25Kb1NkUjlPL2xZVUZvaG84UEhrQ1lJYmpNaElVOU00aHNaRyswU3dDRkNOay9pZmpZUjhUSGlWZ3IwYgpOL2RXajcxUFZZN2F3a0MyYlhrQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZBRnpxT2w3Vi94VURSYkcyQXA1eUJrMUZubEdNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBRjlZQWt4VGhpZE5SREdha2ZKRQo4SUFPNitRYVRvR0FHWVBmd1BNclBKYzJvTzB2eHU0ZjlFL0pKSE5wdDFsdEQ1dVZoTy85MnUvVTZELy9lUnJGCk9jUlBmTHgzNk15ZS8xMzdGeU4wVTNCdUJTcDVybmUzSVdvZjBJZER2YmV1K3NIeUIrTmhDVWhYNVNub1ZaRGwKRzJqeGJoV1pZWEhmYStwYmx3djBqalRwZEhiMDlYZi81Tkhabkh2KytGRzZqTVFERFVWUjFpNFNzNVJ1WS9CNApNcE1oQW5ieWZNM1lSVDVnNUZqRzF2OGNkeTRLenUxN3A1K1ZrTUdpaDBmcklmY1dYTklDQzZzWFFRNXB0TlNKCk9NSlNJVThLNXNNVnhmTVc3VXZQWlNxVDhHa0VTWHIvaXRlRmROR1d1b0plaDNJV24rWWNmb3Z5K3ZXQW9LQ1YKNmlNPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
  token                  = data.aws_eks_cluster_auth.project-mgmt-eks-cluster-rancher-test.token
   exec {
    api_version = "client.authentication.k8s.io/v1"
    command     = "aws"
    args = ["eks", "get-token", "--cluster-name", "project-mgmt-eks-cluster-rancher-test"]    
  }
}

provider "helm" {
  alias = "project-mgmt-eks-cluster-rancher-test"
  kubernetes {      
    host                   = "https://9A5969C874B923B781EC8FA1665988EE.gr7.us-east-2.eks.amazonaws.com"
    cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1EUXhOekE0TXpZME0xb1hEVE16TURReE5EQTRNelkwTTFvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBS1EwCldjV1E1cEVhNFBNTE00N1NGQjJkalUxcGtzdEhkQ1RyZDRRTHd6cGZsOWZjbkVzVnpxUXVmOWZQYndFY1dFYW0Ka2dmZkhNbUZjUWpsVFYrUXVmN1RXMmJFdVg3TEZjUFBCZzM4bmpST21vekdCbVBjdVpZc1Rvd0NNSk13UG1QTwpyU2swaThoSzBWb2plMDlxRUdPMTg2RXNCL08vanZpT3dQaDV5R29OTmttTi9sNmFPWE8wM0c5RWFTSFdrUFRPCk5MRmVMbS9yL1FsbEUyTkpYSUdYWVpnYmlSeUZjWVZTZ09MMzBtSHY2U2Z3U3Ntd2ZMQmZjS2hUWnp1TFhJRkUKU241S25Kb1NkUjlPL2xZVUZvaG84UEhrQ1lJYmpNaElVOU00aHNaRyswU3dDRkNOay9pZmpZUjhUSGlWZ3IwYgpOL2RXajcxUFZZN2F3a0MyYlhrQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZBRnpxT2w3Vi94VURSYkcyQXA1eUJrMUZubEdNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBRjlZQWt4VGhpZE5SREdha2ZKRQo4SUFPNitRYVRvR0FHWVBmd1BNclBKYzJvTzB2eHU0ZjlFL0pKSE5wdDFsdEQ1dVZoTy85MnUvVTZELy9lUnJGCk9jUlBmTHgzNk15ZS8xMzdGeU4wVTNCdUJTcDVybmUzSVdvZjBJZER2YmV1K3NIeUIrTmhDVWhYNVNub1ZaRGwKRzJqeGJoV1pZWEhmYStwYmx3djBqalRwZEhiMDlYZi81Tkhabkh2KytGRzZqTVFERFVWUjFpNFNzNVJ1WS9CNApNcE1oQW5ieWZNM1lSVDVnNUZqRzF2OGNkeTRLenUxN3A1K1ZrTUdpaDBmcklmY1dYTklDQzZzWFFRNXB0TlNKCk9NSlNJVThLNXNNVnhmTVc3VXZQWlNxVDhHa0VTWHIvaXRlRmROR1d1b0plaDNJV24rWWNmb3Z5K3ZXQW9LQ1YKNmlNPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
    token                  = data.aws_eks_cluster_auth.project-mgmt-eks-cluster-rancher-test.token
    exec {
      api_version = "client.authentication.k8s.io/v1"
      command     = "aws"
      args = ["eks", "get-token", "--cluster-name", "project-mgmt-eks-cluster-rancher-test"]    
    }
  }
}

### Important:
### Use this block and disable cert_manager_helm_creation_0 for cleaning up
#module "kubectl_apply_0" {
#  source = "../../../../../../modules/services/eks/addon/cert_manager"
#  providers = { kubernetes = kubernetes.project-mgmt-eks-cluster-rancher-test }
#  aws_region = "${var.aws_region}"
#  aws_access_key = "${var.aws_access_key}"
#  aws_secret_key = "${var.aws_secret_key}"  
#  count_idx = 0
#  clusters = var.clusters
#  aws_caller_identity = data.aws_caller_identity.current.id
#}

module "cert_manager_helm_creation_0" {
  source = "../../../../../../modules/services/eks/addon/helm"
  providers = { helm = helm.project-mgmt-eks-cluster-rancher-test }
  helm_info = local.helm_info[0]  
  helm_module_depends_on = ""
  #helm_module_depends_on = module.kubectl_apply_0
}