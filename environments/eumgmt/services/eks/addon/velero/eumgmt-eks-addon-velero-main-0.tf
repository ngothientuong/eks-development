data "aws_eks_cluster_auth" "project-eumgmt-eks-eu-west-2" {
  name = "project-eumgmt-eks-eu-west-2"
}
provider "kubernetes" {  
  alias = "project-eumgmt-eks-eu-west-2"
  host                   = "https://DD9C03E1D12C707818F395E287C2996B.gr7.eu-west-2.eks.amazonaws.com"
  cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1EUXlNREE0TWpJeU1Gb1hEVE16TURReE56QTRNakl5TUZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBS2VFClJ6UTYxZE5jMy91VTJHRzI0V21qZExIYitVSndXZVlCRXFCbDM4MS9uaG4yLzZUZWhNVVpZcWNwQ2EvcWljbE0Kdm1yNnoxbGR2dVlsZWZYUXY2K0FHbXJlT2g0L3hLck16OVV3QzJoMHl1QWtRV2ZTelI1YjJPM3hwSHlmdHBlSAp5UEY3R1Y4SkJaaXlzeE12ZE5qUUk2RzM2bzhXN2IwU0F2TkRyRjlmZFY4L2dPNHV4bHdKdjc0aDE3b0ZpSGsrCmNialFQRUZDeUlCNjR0bWl1aDhaRmZSZXhMVWlMZm9NZFA4MlZxQkFZL2dYQVNZUTNjbWtaY0YxeHNKYWNGMUgKVU1ia1NmZkNhWVRmVlI0b3ByZndicDNwUHYvL2JSaVN6SmQ1TXJsN3dBb2JnZDdqN1p6S2U3V2dyT0FFSUhSZgpWcVFBQk93b3RneStsVTBENzFVQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZDdlc0bzBmMDZzYzZoR3hFbGo4aDZFYXlLZUZNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBRnU2c1A0TURmVVpUcTFTMEt1cQpRcm44TU0wQmwzazFBYXNsWHNyM2FXYmFjdC9SZUlFWXg1aW1DYjN0ZDZRUlgzTkczaG5UanBaU1hnSGQ2b1ltCndVQ0ZJWVFNeUxlYnZvNTB0eWR0OXJkTUczeFdzQk04RlJjZHFyWXB1VnBYZ0FKZVMzcXhUbkxFZE1uM01HOUQKSGRrUWNDS3hHY2MxMncxRHg0MHUzOVBGQmZRUjBXczkwVDQ5TDljeFM3QytnMk90QzdRQW1MSzF1SmJpamlTUwpnK2cvQXFNQmdZZ0Q2aUFKZlErQjN5VWdCSXJVQjd6TkQ0UWdNZ1U5SFBUUDRQeElZQ202d2t3MHpzTzlTbkFHCmN5azVvaU5VSUVaQjFWQU5xN0Y5Mm4xcnY2azRYa1Q0UUFYeXhrazNEVzVoM0gya2Zmano5Mml1UVgvMGYrVlEKajNnPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
  token                  = data.aws_eks_cluster_auth.project-eumgmt-eks-eu-west-2.token
   exec {
    api_version = "client.authentication.k8s.io/v1"
    command     = "aws"
    args = ["eks", "get-token", "--cluster-name", "project-eumgmt-eks-eu-west-2"]    
  }
}

provider "helm" {
  alias = "project-eumgmt-eks-eu-west-2"
  kubernetes {      
    host                   = "https://DD9C03E1D12C707818F395E287C2996B.gr7.eu-west-2.eks.amazonaws.com"
    cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1EUXlNREE0TWpJeU1Gb1hEVE16TURReE56QTRNakl5TUZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBS2VFClJ6UTYxZE5jMy91VTJHRzI0V21qZExIYitVSndXZVlCRXFCbDM4MS9uaG4yLzZUZWhNVVpZcWNwQ2EvcWljbE0Kdm1yNnoxbGR2dVlsZWZYUXY2K0FHbXJlT2g0L3hLck16OVV3QzJoMHl1QWtRV2ZTelI1YjJPM3hwSHlmdHBlSAp5UEY3R1Y4SkJaaXlzeE12ZE5qUUk2RzM2bzhXN2IwU0F2TkRyRjlmZFY4L2dPNHV4bHdKdjc0aDE3b0ZpSGsrCmNialFQRUZDeUlCNjR0bWl1aDhaRmZSZXhMVWlMZm9NZFA4MlZxQkFZL2dYQVNZUTNjbWtaY0YxeHNKYWNGMUgKVU1ia1NmZkNhWVRmVlI0b3ByZndicDNwUHYvL2JSaVN6SmQ1TXJsN3dBb2JnZDdqN1p6S2U3V2dyT0FFSUhSZgpWcVFBQk93b3RneStsVTBENzFVQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZDdlc0bzBmMDZzYzZoR3hFbGo4aDZFYXlLZUZNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBRnU2c1A0TURmVVpUcTFTMEt1cQpRcm44TU0wQmwzazFBYXNsWHNyM2FXYmFjdC9SZUlFWXg1aW1DYjN0ZDZRUlgzTkczaG5UanBaU1hnSGQ2b1ltCndVQ0ZJWVFNeUxlYnZvNTB0eWR0OXJkTUczeFdzQk04RlJjZHFyWXB1VnBYZ0FKZVMzcXhUbkxFZE1uM01HOUQKSGRrUWNDS3hHY2MxMncxRHg0MHUzOVBGQmZRUjBXczkwVDQ5TDljeFM3QytnMk90QzdRQW1MSzF1SmJpamlTUwpnK2cvQXFNQmdZZ0Q2aUFKZlErQjN5VWdCSXJVQjd6TkQ0UWdNZ1U5SFBUUDRQeElZQ202d2t3MHpzTzlTbkFHCmN5azVvaU5VSUVaQjFWQU5xN0Y5Mm4xcnY2azRYa1Q0UUFYeXhrazNEVzVoM0gya2Zmano5Mml1UVgvMGYrVlEKajNnPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
    token                  = data.aws_eks_cluster_auth.project-eumgmt-eks-eu-west-2.token
    exec {
      api_version = "client.authentication.k8s.io/v1"
      command     = "aws"
      args = ["eks", "get-token", "--cluster-name", "project-eumgmt-eks-eu-west-2"]    
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
  providers = { helm = helm.project-eumgmt-eks-eu-west-2 }
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