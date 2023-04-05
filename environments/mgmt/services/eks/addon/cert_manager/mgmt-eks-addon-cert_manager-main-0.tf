data "aws_eks_cluster_auth" "project-mgmt-eks-cluster-rancher-test" {
  name = "project-mgmt-eks-cluster-rancher-test"
}
provider "kubernetes" {  
  alias = "project-mgmt-eks-cluster-rancher-test"
  host                   = "https://D13A3C493A0CFE9DCBEAFE5639226574.gr7.us-east-2.eks.amazonaws.com"
  cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1ETXlOVEF5TVRNME9Gb1hEVE16TURNeU1qQXlNVE0wT0Zvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBUEx3CkdrbHRrcHp4ckJvUk52dzQzWW5vbHc1eTVITENXQXN4bU9GejYzY0VzakNraDY0U0JhR1NJdFUxcFNienhzSFUKTG9SMW5PZDJSYzBBNHlidkNYMHB2dSs2Q2d5cHRJa1JmMWw4S1hJVTNjT1FHSGpGT0VncjdOVU03U0pDLzZXVgoraTQvL0N6UkdqSTFsckRURzRKdkx5UlBBSXF5eXFrZ1RrL3ZoK2RMVDNFaXN6UitxSE1LeTFuTUVvaXRoQVhlCmVYUU5WQlhCUnFsei9mL2FxaHV3Myt3bThrbG9tYmRPUEtadzM1QmxJamhkQXphSkhONnNOYUc4cnRJTUpkMzcKSFd0WXJ1SGczVzBtTjJnVy94akM3KysveWpaZ0dUMDQ5MjR2UU1qMUJKMEY2QllHQkJvL1VsNGFVQzJET0VSUAp2MXdTVFc1RkR5VDkyL2diVmswQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZCS1BhUnV4RXhZS1lJZXJoTitzUzB5czU5dXVNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBQWFXMStJUTJxeFpLdVRjbjV6QQpETWtBZk95WVZaUDFFcHF3SktaYUxaN2dkaDFFVU90TzFUckVqR3J4bytMS1Z3YW92bXF4SWQvQzlMUXFFYUVoCjJzaW8rNjdxSW5DZE1rVy8wd01uSUZNbWcxa2lyRUZNb2VCb2FCeDN1aCtGclRoM3FWVWZ4cGNsQ2lOMmhCaUwKbTEwMFdCemhxbnBvRFRoeXMzemNicktobWhPU1pWYnpmR1dteDVGTzVlWlFMUHpMUGgxaXpHbk11K29Ld3kzVApjQ3dEb0xLNDZqWGNjMGlzTWIyL08xRmpKN0NkanM1NjZOaXdxZUdTeFhMS2lERWRkNlNIREFaNnpWdmlyUWtGClZiQ1FNSWU2bXhKYzlKWHAvblVLUWpiL3V6dGI3TkdXTlMxVkdMeWtlVisyaWFEb203THVpaEVpZ25OWGlkN3kKNk40PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
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
    host                   = "https://D13A3C493A0CFE9DCBEAFE5639226574.gr7.us-east-2.eks.amazonaws.com"
    cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1ETXlOVEF5TVRNME9Gb1hEVE16TURNeU1qQXlNVE0wT0Zvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBUEx3CkdrbHRrcHp4ckJvUk52dzQzWW5vbHc1eTVITENXQXN4bU9GejYzY0VzakNraDY0U0JhR1NJdFUxcFNienhzSFUKTG9SMW5PZDJSYzBBNHlidkNYMHB2dSs2Q2d5cHRJa1JmMWw4S1hJVTNjT1FHSGpGT0VncjdOVU03U0pDLzZXVgoraTQvL0N6UkdqSTFsckRURzRKdkx5UlBBSXF5eXFrZ1RrL3ZoK2RMVDNFaXN6UitxSE1LeTFuTUVvaXRoQVhlCmVYUU5WQlhCUnFsei9mL2FxaHV3Myt3bThrbG9tYmRPUEtadzM1QmxJamhkQXphSkhONnNOYUc4cnRJTUpkMzcKSFd0WXJ1SGczVzBtTjJnVy94akM3KysveWpaZ0dUMDQ5MjR2UU1qMUJKMEY2QllHQkJvL1VsNGFVQzJET0VSUAp2MXdTVFc1RkR5VDkyL2diVmswQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZCS1BhUnV4RXhZS1lJZXJoTitzUzB5czU5dXVNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBQWFXMStJUTJxeFpLdVRjbjV6QQpETWtBZk95WVZaUDFFcHF3SktaYUxaN2dkaDFFVU90TzFUckVqR3J4bytMS1Z3YW92bXF4SWQvQzlMUXFFYUVoCjJzaW8rNjdxSW5DZE1rVy8wd01uSUZNbWcxa2lyRUZNb2VCb2FCeDN1aCtGclRoM3FWVWZ4cGNsQ2lOMmhCaUwKbTEwMFdCemhxbnBvRFRoeXMzemNicktobWhPU1pWYnpmR1dteDVGTzVlWlFMUHpMUGgxaXpHbk11K29Ld3kzVApjQ3dEb0xLNDZqWGNjMGlzTWIyL08xRmpKN0NkanM1NjZOaXdxZUdTeFhMS2lERWRkNlNIREFaNnpWdmlyUWtGClZiQ1FNSWU2bXhKYzlKWHAvblVLUWpiL3V6dGI3TkdXTlMxVkdMeWtlVisyaWFEb203THVpaEVpZ25OWGlkN3kKNk40PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
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