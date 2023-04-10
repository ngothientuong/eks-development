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

# resource "null_resource" "create_access_key_file_0" {
#   triggers = {
#     always_run = "${timestamp()}"
#   }
#   provisioner "local-exec" {
#     interpreter = ["bash", "-c"]
#     command     = <<EOT
#     echo [default] > ~/.velero
#     echo aws_access_key_id=${var.aws_access_key} >> ~/.velero
#     echo aws_secret_access_key=${var.aws_access_key} >> ~/.velero
#     EOT
#   }
# }

module "velero_helm_creation_0" {
  source = "../../../../../../modules/services/eks/addon/helm"
  providers = { helm = helm.project-mgmt-eks-cluster-rancher-test }
  helm_info = local.helm_info[0]    
  helm_module_depends_on = null
}

resource "null_resource" "install_velero_0" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<EOT
    wget https://github.com/vmware-tanzu/velero/releases/download/v1.10.2/velero-v1.10.2-linux-amd64.tar.gz && tar -xf velero-v1.10.2-linux-amd64.tar.gz velero-v1.10.2-linux-amd64/velero ;
    sudo mv velero-v1.10.2-linux-amd64/velero /usr/local/bin
    rm -rf velero-v1.10.2-linux-amd64*
    EOT
  }
  depends_on = [module.velero_helm_creation_0]
}