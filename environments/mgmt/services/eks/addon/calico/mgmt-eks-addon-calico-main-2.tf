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

# resource "null_resource" "create_access_key_file_2" {
#   triggers = {
#     always_run = "${timestamp()}"
#   }
#   provisioner "local-exec" {
#     interpreter = ["bash", "-c"]
#     command     = <<EOT
#     echo [default] > ~/.calico
#     echo aws_access_key_id=${var.aws_access_key} >> ~/.calico
#     echo aws_secret_access_key=${var.aws_access_key} >> ~/.calico
#     EOT
#   }
# }

module "calico_helm_creation_2" {
  source = "../../../../../../modules/services/eks/addon/helm"
  providers = { helm = helm.project-mgmt-eks-cluster-int-2 }
  helm_info = local.helm_info[2]    
  helm_module_depends_on = null
}

resource "null_resource" "install_calico_2" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<EOT
    if [ "$(whereis kubectl-calico)" == "" ]
    then 
      curl -L https://github.com/projectcalico/calico/releases/latest/download/calicoctl-linux-amd64 -o kubectl-calico
      chmod +x kubectl-calico
      sudo mv kubectl-calico /usr/local/bin    
    fi
    if [ "$(whereis calicoctl)" == "" ]
    then
    curl -L https://github.com/projectcalico/calico/releases/latest/download/calicoctl-linux-amd64 -o calicoctl
    chmod +x ./calicoctl
    sudo mv ./calicoctl /usr/local/bin 
    fi
    EOT
  }
  depends_on = [module.calico_helm_creation_2]
}


resource "null_resource" "module_set_initial_state_2" {
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

module "calico_kubectl_2" {
  source = "../../../../../../modules/services/eks/addon/generic_kubectl"
  aws_region = "${var.aws_region}"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"  
  aws_caller_identity = data.aws_caller_identity.current.id  
  clusters = var.clusters
  clusters_info = local.clusters_info[2]
  service_account_role_arns = local.service_account_role_arns
  sub_path = local.sub_path
  root_depends_on = null_resource.module_set_initial_state_2
  module_count = 2
}