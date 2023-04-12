data "aws_eks_cluster_auth" "project-mgmt-eks-cluster-int-test" {
  name = "project-mgmt-eks-cluster-int-test"
}
provider "kubernetes" {  
  alias = "project-mgmt-eks-cluster-int-test"
  host                   = "https://93C08E0ADD36AFEBF2B86F0EE63F6B3B.gr7.us-east-2.eks.amazonaws.com"
  cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1EUXhNakEzTWpnd01Gb1hEVE16TURRd09UQTNNamd3TUZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTW51CnFRSE5QTkIva2NrWWJLS0orbVdqaHo5VS9sQkxRa3gzcjc2VnFYRXFDZWpjd0x2c1hyUDhleis2dE9Tc0ZIWTcKaE5UbEdReXJRenRuVHlhVkEyQWdMNk5XMG0yaXlNSWg4S0lIaThHTHFOc0NyQ3VTbXhldE90QmIvVVRMV2ZSYQpWbG8raGh2RCtSWTcycCtBdjFmdkZ2ellONTg1ZXhmRlBvK2VDVmtkdExrQ1FRWjhjb28rZzZGSVZmWjNqOXNRClhLZmlEZVh1azBDK00zNmo2cUxaR1BtdDhVK28xeUpyMUJCdDV0QzU1dVZsWXZaMFhBOGYyaG1aZjYwUVJYMDcKandMdURLM3VFYy85WXZLOExrcG1lVHVQWVFyWEpwbWY2dC8xeXpjUXFWb05OQVorcjJ4S1N1MXFCS05CVHI4cwpxQkhYamdNbjl5WGM2RzRxeXdNQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZLc0pQc3BERGx6aysxcWFnWE9Qa2ZHaXZ4bzNNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBSzY1UVdZMjI2cDVwc05HTlNONwpmZm1GemtzZzFJMi8wL0pUMFV3QjVlRmsrSGVaaUptL0JJdTdQVDdQb2dLdDZiemxiRmozTTZQZU5pblZjTm9SCm1XRk9nMHFpck5EVUFIcVBiVlVYdUJGWGp3dlYyNUc2NHdpUE5BNVZHSWdlNVdqcXJ4QjRSYVlGeVcwTFJobmUKcURhL1k3UWdkaXY3TVZmVlg4THBtdnFJa0ZWRlgzd2dtSk5Hc3A4NEFRa09CRExodmEvbEkraU9pQzdHZDdFaAo2K1J1R0tWclRiM0hPaVg2LzVOYXVoT0szWDRMbjRJQ0kzc3B6Z3Y4WXBlZnV6eXFoWlh3bHFpTERMN0ErNHpRCmpkaU8raitTa2VjTEo0Z0JwS0cxYmJlOUtpakMvVHNBR2Zvd1A3aE56MUV3UEN0QzRpbFZkOFZDcGN5MEhLc0oKYkowPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
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
    host                   = "https://93C08E0ADD36AFEBF2B86F0EE63F6B3B.gr7.us-east-2.eks.amazonaws.com"
    cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1EUXhNakEzTWpnd01Gb1hEVE16TURRd09UQTNNamd3TUZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTW51CnFRSE5QTkIva2NrWWJLS0orbVdqaHo5VS9sQkxRa3gzcjc2VnFYRXFDZWpjd0x2c1hyUDhleis2dE9Tc0ZIWTcKaE5UbEdReXJRenRuVHlhVkEyQWdMNk5XMG0yaXlNSWg4S0lIaThHTHFOc0NyQ3VTbXhldE90QmIvVVRMV2ZSYQpWbG8raGh2RCtSWTcycCtBdjFmdkZ2ellONTg1ZXhmRlBvK2VDVmtkdExrQ1FRWjhjb28rZzZGSVZmWjNqOXNRClhLZmlEZVh1azBDK00zNmo2cUxaR1BtdDhVK28xeUpyMUJCdDV0QzU1dVZsWXZaMFhBOGYyaG1aZjYwUVJYMDcKandMdURLM3VFYy85WXZLOExrcG1lVHVQWVFyWEpwbWY2dC8xeXpjUXFWb05OQVorcjJ4S1N1MXFCS05CVHI4cwpxQkhYamdNbjl5WGM2RzRxeXdNQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZLc0pQc3BERGx6aysxcWFnWE9Qa2ZHaXZ4bzNNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBSzY1UVdZMjI2cDVwc05HTlNONwpmZm1GemtzZzFJMi8wL0pUMFV3QjVlRmsrSGVaaUptL0JJdTdQVDdQb2dLdDZiemxiRmozTTZQZU5pblZjTm9SCm1XRk9nMHFpck5EVUFIcVBiVlVYdUJGWGp3dlYyNUc2NHdpUE5BNVZHSWdlNVdqcXJ4QjRSYVlGeVcwTFJobmUKcURhL1k3UWdkaXY3TVZmVlg4THBtdnFJa0ZWRlgzd2dtSk5Hc3A4NEFRa09CRExodmEvbEkraU9pQzdHZDdFaAo2K1J1R0tWclRiM0hPaVg2LzVOYXVoT0szWDRMbjRJQ0kzc3B6Z3Y4WXBlZnV6eXFoWlh3bHFpTERMN0ErNHpRCmpkaU8raitTa2VjTEo0Z0JwS0cxYmJlOUtpakMvVHNBR2Zvd1A3aE56MUV3UEN0QzRpbFZkOFZDcGN5MEhLc0oKYkowPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
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