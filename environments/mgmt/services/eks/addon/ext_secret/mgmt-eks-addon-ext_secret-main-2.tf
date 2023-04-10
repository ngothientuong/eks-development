data "aws_eks_cluster_auth" "project-mgmt-eks-cluster-int-2" {
  name = "project-mgmt-eks-cluster-int-2"
}
provider "kubernetes" {  
  alias = "project-mgmt-eks-cluster-int-2"
  host                   = "https://76B57166E1C563E1863340023634E84D.gr7.us-east-2.eks.amazonaws.com"
  cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1EUXhNREEwTURJME1Wb1hEVE16TURRd056QTBNREkwTVZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBSmU0CnZsVnFaWkxiaHkxUWZhVzdqUkpVMlRBdWQ2RER0THRiWEdOUUJod2pnNmdVQThJRzNoYXdYVVM4M0FGVkVJcEgKYlF1NXlnWTc2Y2k5SEpaR1hURnVYeXNZZzc5QkxKbDBSUjVjR1RxRXozdGQ3bjQwaVozQWIxOThMQ0FGUkZpNAo2RFN1YTYvUEluL1lTZlRDRkxrenlEREJFQVZ0cFZGWldFeXpEalI4OWo5em50RHFNdmdPejZLZ21icG9mVW1tCmRZR1M2Tmk5VzJmTHg0aWpWeENVb2JpMVlvcnkzdFJ5TnJXZFpIT3NjcEh1V2xpeGdocCtvTkc5L28wOXNEcm8KNjBvWVE0TWZwcGNDVHNEWHYwc2pHWkZ3RFl0VUkxcVVxWitYVXpEMW9qc1hZdXA5WTZSa2hrTEJCSnVyWjFENAphcngvSHZyY3BFZG1kaklpSkhNQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZCSkZYZlBXUGgyeStnRnhhSkg3NFdiL1o0L2pNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBRGR4VzRpZjdHR3BzM2RGZ3FOUgpNcVMyaTFiekpPa0taSGtZd01KaW11SUhnUGxPUkFub1BwR2NhampxM0VJVXBVamVydkg1ZVBlSFlFb3U3K1NCCmh2K3dXVElINGx1Ti9Ramk1aklzZEs4N01ranN3aFRzR2hYaFE0R1lvcEEvZVB1Zks2bTRQYm1rRStkV2JVOHkKd2htYkFhVWFURFdBUE5uWExUV3lCK1d5RnZUWW1hZWtZQ2Z6aFIxTmdHOWtKL2tNdXlYa2s5UWpjR0R1RTRnSQovVU1FTEt4OVhidnlERU5jYmZzYk9iTW82cS9rU0lMdWNOcDNtTGExQ1hYa1lOTmZTbnB3R3dTVHpxZUdRbEVzCktLWXlDYXQ4dW51YytmKzk3NXRaVVZ5Mm56WEFMTE5abHRpZlpDMTJxZFYyT28rSkY3b1Jrd3NsMzhWTkFSY2kKc2dzPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
  token                  = data.aws_eks_cluster_auth.project-mgmt-eks-cluster-int-2.token
   exec {
    api_version = "client.authentication.k8s.io/v1"
    command     = "aws"
    args = ["eks", "get-token", "--cluster-name", "project-mgmt-eks-cluster-int-2"]    
  }
}

provider "helm" {
  alias = "project-mgmt-eks-cluster-int-2"
  kubernetes {      
    host                   = "https://76B57166E1C563E1863340023634E84D.gr7.us-east-2.eks.amazonaws.com"
    cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1EUXhNREEwTURJME1Wb1hEVE16TURRd056QTBNREkwTVZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBSmU0CnZsVnFaWkxiaHkxUWZhVzdqUkpVMlRBdWQ2RER0THRiWEdOUUJod2pnNmdVQThJRzNoYXdYVVM4M0FGVkVJcEgKYlF1NXlnWTc2Y2k5SEpaR1hURnVYeXNZZzc5QkxKbDBSUjVjR1RxRXozdGQ3bjQwaVozQWIxOThMQ0FGUkZpNAo2RFN1YTYvUEluL1lTZlRDRkxrenlEREJFQVZ0cFZGWldFeXpEalI4OWo5em50RHFNdmdPejZLZ21icG9mVW1tCmRZR1M2Tmk5VzJmTHg0aWpWeENVb2JpMVlvcnkzdFJ5TnJXZFpIT3NjcEh1V2xpeGdocCtvTkc5L28wOXNEcm8KNjBvWVE0TWZwcGNDVHNEWHYwc2pHWkZ3RFl0VUkxcVVxWitYVXpEMW9qc1hZdXA5WTZSa2hrTEJCSnVyWjFENAphcngvSHZyY3BFZG1kaklpSkhNQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZCSkZYZlBXUGgyeStnRnhhSkg3NFdiL1o0L2pNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBRGR4VzRpZjdHR3BzM2RGZ3FOUgpNcVMyaTFiekpPa0taSGtZd01KaW11SUhnUGxPUkFub1BwR2NhampxM0VJVXBVamVydkg1ZVBlSFlFb3U3K1NCCmh2K3dXVElINGx1Ti9Ramk1aklzZEs4N01ranN3aFRzR2hYaFE0R1lvcEEvZVB1Zks2bTRQYm1rRStkV2JVOHkKd2htYkFhVWFURFdBUE5uWExUV3lCK1d5RnZUWW1hZWtZQ2Z6aFIxTmdHOWtKL2tNdXlYa2s5UWpjR0R1RTRnSQovVU1FTEt4OVhidnlERU5jYmZzYk9iTW82cS9rU0lMdWNOcDNtTGExQ1hYa1lOTmZTbnB3R3dTVHpxZUdRbEVzCktLWXlDYXQ4dW51YytmKzk3NXRaVVZ5Mm56WEFMTE5abHRpZlpDMTJxZFYyT28rSkY3b1Jrd3NsMzhWTkFSY2kKc2dzPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
    token                  = data.aws_eks_cluster_auth.project-mgmt-eks-cluster-int-2.token
    exec {
      api_version = "client.authentication.k8s.io/v1"
      command     = "aws"
      args = ["eks", "get-token", "--cluster-name", "project-mgmt-eks-cluster-int-2"]    
    }
  }
}

module "ext_secret_helm_creation_2" {
  source = "../../../../../../modules/services/eks/addon/helm"
  providers = { helm = helm.project-mgmt-eks-cluster-int-2 }
  helm_info = local.helm_info[2]  
  helm_module_depends_on = ""
  #helm_module_depends_on = module.kubectl_apply_2
}