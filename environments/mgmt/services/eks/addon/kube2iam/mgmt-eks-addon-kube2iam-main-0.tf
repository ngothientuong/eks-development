data "aws_eks_cluster_auth" "project-mgmt-eks-cluster-rancher-test" {
  name = "project-mgmt-eks-cluster-rancher-test"
}
provider "kubernetes" {  
  alias = "project-mgmt-eks-cluster-rancher-test"
  host                   = "https://533E5A3795B60CB3C47A434A7F446B41.gr7.us-east-2.eks.amazonaws.com"
  cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1EUXhNREEwTURNeU5sb1hEVE16TURRd056QTBNRE15Tmxvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBT3NmCi83N0cvVnFMcTJTb0h4dlRwd2FGM2RCZVdWeTYzbHIzWWxVQklONy9zaXRSaXRpcXlCdC9ORFFBOGtWL3FKeUIKWnVEanQrV2FmNFRkVFRDWmt2T2FSdHEyUTQ4clZiVWtjNlpyZzFZN3VRRDl5RW9XeVFocVU3TkFXWHJNNmcycApJYXZzUVF3Zng5ZlNQUDVpWlU5allJM0pOZ2xwMUo1VW5UcmF1Q2x3dXdDZjU3TVpadCt5blc2ZXhqY1BlaDAyCnJZblcvK0NuTXRSeUlBTkdzMFI4UFYyM010M1UvSGUvcjVPMGpweEVHUWNYZG1hL1NvSy9QMWNrRG1SVDJsOUwKYUN1ZGlZNDFWcmFxQ0Z1WXEwODVweTVFU2tzZGhxWk0wbjFMd3VmZWtPTi8zMFJGWHhSMytTeGFuUVUvQUpYNwpsNDhYR2VueGVGUTM5bUt2OHdjQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZNMG5KSjJhYW4xMDVFaExSeGZpRnhYUzdWcTNNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBTlYrbGVLVVRpeXJOZTkxdkwxYgpybkRRV2ZNcE1QbGhoQ1pGUkNwM29iRlllbDdxL2RJNjEremg2Q05NdzZsbkxTT0lOcjJFTjFQMUlEUHo2bWhwCmg4MlJtQ1pwWWxwTXl3b0tGblQvKzVmQ3djODdaMHl0bWUzZ01PVk5ieWJVdHZFakowSXJRTFdYSjhabUgwSDAKdHBvWk4wWlArb2tGeWViNkd5VWFxSVVGQWt3MGJWdGJSNFh0aFdScEp6TmhVVVlMd1dZa00wWERXSmlkVDRnUgowSzArWXhZbk9FTVdTS0U0cGFwclBqUGMrbGluMGJzOGk1NSt3S2w1amJmdjlBK29UR09CZklvUVNIK09hR09CClNORllFdVRISXljNTFUd2RaMk4yZFhHakI2Szd1QzlOem9JYXNGWDNkVnVmcVE0ZUhBRTJ6Y3Y5Q1pFRithMm8KWkRrPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
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
    host                   = "https://533E5A3795B60CB3C47A434A7F446B41.gr7.us-east-2.eks.amazonaws.com"
    cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1EUXhNREEwTURNeU5sb1hEVE16TURRd056QTBNRE15Tmxvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBT3NmCi83N0cvVnFMcTJTb0h4dlRwd2FGM2RCZVdWeTYzbHIzWWxVQklONy9zaXRSaXRpcXlCdC9ORFFBOGtWL3FKeUIKWnVEanQrV2FmNFRkVFRDWmt2T2FSdHEyUTQ4clZiVWtjNlpyZzFZN3VRRDl5RW9XeVFocVU3TkFXWHJNNmcycApJYXZzUVF3Zng5ZlNQUDVpWlU5allJM0pOZ2xwMUo1VW5UcmF1Q2x3dXdDZjU3TVpadCt5blc2ZXhqY1BlaDAyCnJZblcvK0NuTXRSeUlBTkdzMFI4UFYyM010M1UvSGUvcjVPMGpweEVHUWNYZG1hL1NvSy9QMWNrRG1SVDJsOUwKYUN1ZGlZNDFWcmFxQ0Z1WXEwODVweTVFU2tzZGhxWk0wbjFMd3VmZWtPTi8zMFJGWHhSMytTeGFuUVUvQUpYNwpsNDhYR2VueGVGUTM5bUt2OHdjQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZNMG5KSjJhYW4xMDVFaExSeGZpRnhYUzdWcTNNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBTlYrbGVLVVRpeXJOZTkxdkwxYgpybkRRV2ZNcE1QbGhoQ1pGUkNwM29iRlllbDdxL2RJNjEremg2Q05NdzZsbkxTT0lOcjJFTjFQMUlEUHo2bWhwCmg4MlJtQ1pwWWxwTXl3b0tGblQvKzVmQ3djODdaMHl0bWUzZ01PVk5ieWJVdHZFakowSXJRTFdYSjhabUgwSDAKdHBvWk4wWlArb2tGeWViNkd5VWFxSVVGQWt3MGJWdGJSNFh0aFdScEp6TmhVVVlMd1dZa00wWERXSmlkVDRnUgowSzArWXhZbk9FTVdTS0U0cGFwclBqUGMrbGluMGJzOGk1NSt3S2w1amJmdjlBK29UR09CZklvUVNIK09hR09CClNORllFdVRISXljNTFUd2RaMk4yZFhHakI2Szd1QzlOem9JYXNGWDNkVnVmcVE0ZUhBRTJ6Y3Y5Q1pFRithMm8KWkRrPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
    token                  = data.aws_eks_cluster_auth.project-mgmt-eks-cluster-rancher-test.token
    exec {
      api_version = "client.authentication.k8s.io/v1"
      command     = "aws"
      args = ["eks", "get-token", "--cluster-name", "project-mgmt-eks-cluster-rancher-test"]    
    }
  }
}

resource "null_resource" "module_set_initial_state_0" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<EOT
    echo 0 > ~/module_count
    EOT
  }
}

module "kube2iam_0" {
  source = "../../../../../../modules/services/eks/addon/generic_kubectl"
  aws_region = "${var.aws_region}"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"  
  aws_caller_identity = data.aws_caller_identity.current.id  
  clusters = var.clusters
  clusters_info = local.clusters_info[0]
  service_account_role_arns = local.service_account_role_arns
  sub_path = local.sub_path
  root_depends_on = null_resource.module_set_initial_state_0
  module_count = 0
}