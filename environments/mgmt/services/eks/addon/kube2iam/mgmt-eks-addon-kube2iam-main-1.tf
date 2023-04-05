data "aws_eks_cluster_auth" "project-mgmt-eks-cluster-int-test" {
  name = "project-mgmt-eks-cluster-int-test"
}
provider "kubernetes" {  
  alias = "project-mgmt-eks-cluster-int-test"
  host                   = "https://87FE42E2F4258886AAD287E4F42B393B.gr7.us-east-2.eks.amazonaws.com"
  cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1ETXlOVEF5TVRNd01Gb1hEVE16TURNeU1qQXlNVE13TUZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBSnpKCmQvV0dQdnN2ZVozTkhYOGVVVFdQQkZ2UWdqd3JjNURoZ29CNHNiR0VHRXllcVhnbDU3UDBUL3FFOXpBSnpTcUIKVmNUeUI1Yld0NU1WWVV3SkZUck1IS1pCc1g0Nk1WMWFVT3BCL3NNaGRGQzFxa1BOblpjQWsreC8rMlNUSWRKSApGTVcxRGpIcFZNVU4rMXh0akt2cWo3MXExNVFDaGw4c3AvQjlkZE1rd285bmdTdk8zNU9jUG50ZkxZZWxOMkEzClVKbFVPRDlXSXNROHBTcTlXcjZGWHlUcGh1UnJDaXNlUUZ4Z2x2b2JDRmFsS3VwR0NGdnYwZzBXdE9CRnl6bkkKektMUk1nN1dNT1Zsb1BzdFJQdFpXMmlYcTFJNlcvbXcvdXJLdEVKL09IWEJIdmIycHUyM3BibmhjbDM1cVdieQpBQnBBVy9jU0N5aStXNFU5eEtVQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZIenpML2xsVTZuYXR4eUx5NHNONGFoRnJqS2VNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBSFQ5d1hmekRLVk9qRXZnQUFkQgpoMERIbkdDRTBUV3dXeGlIKys5bUFYdGI5Z0R3NmhnaWw4dWU0bHBxaGxPU2JaMTE2UGdPKytlcjRrakZmSmRtClUvaVdiY2dGK1QwVHQ1eUJCMnV2Nk4xNXpZNjF0ZWYvS1FvZS9sdWtsYW5uZmJHRHJaaXNWOCtXRmZ4aEgvTDkKS0ZlY2VFVVA5aUFqcVZXL3R5Sk1md2VldExqWHNSSzNFUDBCWVM3SW42Wms5YTIvdUVkUWo3djVLeXorbDRHNApqbEZzTENVTEk4RXdhZTRYYXI5dWtUVEd0UTR3WjlxZytHS0lSMEJ1NEx4Y3BRNVAwd2gvZnM3VVdRbVBQajRtClgzMHZEaHNzd080NmZ1Y242NW4rVFZvc0dhTWNTN1pTcnhaU1dDQkZrVjlKVmN6MHBxVW1NUDM3OHJmTFFFWG4KSlJJPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
  token                  = data.aws_eks_cluster_auth.project-mgmt-eks-cluster-int-test.token
   exec {
    api_version = "client.authentication.k8s.io/v1"
    command     = "aws"
    args = ["eks", "get-token", "--cluster-name", "project-mgmt-eks-cluster-int-test"]    
  }
}

provider "helm" {
  alias = "project-mgmt-eks-cluster-int-test"
  kubernetes {      
    host                   = "https://87FE42E2F4258886AAD287E4F42B393B.gr7.us-east-2.eks.amazonaws.com"
    cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1ETXlOVEF5TVRNd01Gb1hEVE16TURNeU1qQXlNVE13TUZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBSnpKCmQvV0dQdnN2ZVozTkhYOGVVVFdQQkZ2UWdqd3JjNURoZ29CNHNiR0VHRXllcVhnbDU3UDBUL3FFOXpBSnpTcUIKVmNUeUI1Yld0NU1WWVV3SkZUck1IS1pCc1g0Nk1WMWFVT3BCL3NNaGRGQzFxa1BOblpjQWsreC8rMlNUSWRKSApGTVcxRGpIcFZNVU4rMXh0akt2cWo3MXExNVFDaGw4c3AvQjlkZE1rd285bmdTdk8zNU9jUG50ZkxZZWxOMkEzClVKbFVPRDlXSXNROHBTcTlXcjZGWHlUcGh1UnJDaXNlUUZ4Z2x2b2JDRmFsS3VwR0NGdnYwZzBXdE9CRnl6bkkKektMUk1nN1dNT1Zsb1BzdFJQdFpXMmlYcTFJNlcvbXcvdXJLdEVKL09IWEJIdmIycHUyM3BibmhjbDM1cVdieQpBQnBBVy9jU0N5aStXNFU5eEtVQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZIenpML2xsVTZuYXR4eUx5NHNONGFoRnJqS2VNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBSFQ5d1hmekRLVk9qRXZnQUFkQgpoMERIbkdDRTBUV3dXeGlIKys5bUFYdGI5Z0R3NmhnaWw4dWU0bHBxaGxPU2JaMTE2UGdPKytlcjRrakZmSmRtClUvaVdiY2dGK1QwVHQ1eUJCMnV2Nk4xNXpZNjF0ZWYvS1FvZS9sdWtsYW5uZmJHRHJaaXNWOCtXRmZ4aEgvTDkKS0ZlY2VFVVA5aUFqcVZXL3R5Sk1md2VldExqWHNSSzNFUDBCWVM3SW42Wms5YTIvdUVkUWo3djVLeXorbDRHNApqbEZzTENVTEk4RXdhZTRYYXI5dWtUVEd0UTR3WjlxZytHS0lSMEJ1NEx4Y3BRNVAwd2gvZnM3VVdRbVBQajRtClgzMHZEaHNzd080NmZ1Y242NW4rVFZvc0dhTWNTN1pTcnhaU1dDQkZrVjlKVmN6MHBxVW1NUDM3OHJmTFFFWG4KSlJJPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
    token                  = data.aws_eks_cluster_auth.project-mgmt-eks-cluster-int-test.token
    exec {
      api_version = "client.authentication.k8s.io/v1"
      command     = "aws"
      args = ["eks", "get-token", "--cluster-name", "project-mgmt-eks-cluster-int-test"]    
    }
  }
}

resource "null_resource" "module_set_initial_state_1" {
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

module "kube2iam_1" {
  source = "../../../../../../modules/services/eks/addon/generic_kubectl"
  aws_region = "${var.aws_region}"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"  
  aws_caller_identity = data.aws_caller_identity.current.id  
  clusters = var.clusters
  clusters_info = local.clusters_info[1]
  service_account_role_arns = local.service_account_role_arns
  sub_path = local.sub_path
  root_depends_on = null_resource.module_set_initial_state_1
  module_count = 1
}