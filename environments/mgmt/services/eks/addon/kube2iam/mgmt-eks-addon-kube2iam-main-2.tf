data "aws_eks_cluster_auth" "project-mgmt-eks-cluster-int-2" {
  name = "project-mgmt-eks-cluster-int-2"
}
provider "kubernetes" {  
  alias = "project-mgmt-eks-cluster-int-2"
  host                   = "https://5E7A1F7119EC1B3A4AEA414E93D048D8.gr7.us-east-2.eks.amazonaws.com"
  cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1EUXhNakEzTWpnd09Gb1hEVE16TURRd09UQTNNamd3T0Zvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTk1RCnE5dVpiSmYzT0pOTkRjKzczeHlKOFNySVpBVFRJTzBpazVxS1ZEZTVqMjVHcm1pU0c3cHhGREZZTngzeElmRTgKejZwSFRiOHdReUZWSmlmVHZhODV6Q2FpT3VGOTlSeDQwajJ0VGJJL2dJSnBUSUtGMGJIM1Q4bUZtdkdvLzlZNQpiUDZrVk5qUENoUWY5YlhlTzZQdTlvWmZLRjhBYlR5VTVHZGR2SnFZY0x2VnNOdDhMdVNJcHN2bHdVTHppV1ZUCmJUbWM1d0FmUnQwNnNrT0UrQi8wYmd3WG5TRTFwWW1LNDdtYkh6b0NrNHpKazR2ZnFoR0oxMllqSHFFOHRoeEMKcndRWFoyK25LTGRvMDFSZERNMFM1bkUvaUVrUUgybjlzZUVGVmRNRXNwMUZnQzlJTElpeWE1MVZiMXpqSllmQQp1MXJVODEzSXF1dkNGTEt3ckhFQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZQWmlLNExWRkpaYm9oT1ljdW1qZ25HZy9uaHVNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBTXgzdFR3OVM4dGZSNTBybDBnOQpvdW9WcUJ4bm9YbENGVHUybjdCd3REeVkwaHBISzZrZEU0Z1NETFRkK1RoZUhQTEhwL2Y1eFJXM3pKY2VEcHlMCnVndTFRR0JYdzRSS0NnUmtwcWRTTTFTSS95Q01vK05KbXZqdkNvdkJUeUtabjB6TjdjOUpqMjdRQUtUVE5hU28KRXVUSzJPcWR3ZnZydGdIODdERTRnWnoyRXdKeTMySXZvVWV4UHZnVGRqbUJvbHErTGQ2Qy9nc3JKVlJHUUNGOQo3ekt5UkZEeDlnNmxKKzZkdGlPOHBRK281WVJoYUlVN1l4V3dJQzZxdkFHeUdQR2dSeDJyWERFaGVJNHhRQjd3Clk2UFBIbzZjQ1hZSjlJTjJoUzhjcTNFYnh2dXo5bk9LbkNBSk54REppVk5lakpQRWVsOUUrb2s2a1J6aTRlZ3UKOVJBPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
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
    host                   = "https://5E7A1F7119EC1B3A4AEA414E93D048D8.gr7.us-east-2.eks.amazonaws.com"
    cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1EUXhNakEzTWpnd09Gb1hEVE16TURRd09UQTNNamd3T0Zvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTk1RCnE5dVpiSmYzT0pOTkRjKzczeHlKOFNySVpBVFRJTzBpazVxS1ZEZTVqMjVHcm1pU0c3cHhGREZZTngzeElmRTgKejZwSFRiOHdReUZWSmlmVHZhODV6Q2FpT3VGOTlSeDQwajJ0VGJJL2dJSnBUSUtGMGJIM1Q4bUZtdkdvLzlZNQpiUDZrVk5qUENoUWY5YlhlTzZQdTlvWmZLRjhBYlR5VTVHZGR2SnFZY0x2VnNOdDhMdVNJcHN2bHdVTHppV1ZUCmJUbWM1d0FmUnQwNnNrT0UrQi8wYmd3WG5TRTFwWW1LNDdtYkh6b0NrNHpKazR2ZnFoR0oxMllqSHFFOHRoeEMKcndRWFoyK25LTGRvMDFSZERNMFM1bkUvaUVrUUgybjlzZUVGVmRNRXNwMUZnQzlJTElpeWE1MVZiMXpqSllmQQp1MXJVODEzSXF1dkNGTEt3ckhFQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZQWmlLNExWRkpaYm9oT1ljdW1qZ25HZy9uaHVNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBTXgzdFR3OVM4dGZSNTBybDBnOQpvdW9WcUJ4bm9YbENGVHUybjdCd3REeVkwaHBISzZrZEU0Z1NETFRkK1RoZUhQTEhwL2Y1eFJXM3pKY2VEcHlMCnVndTFRR0JYdzRSS0NnUmtwcWRTTTFTSS95Q01vK05KbXZqdkNvdkJUeUtabjB6TjdjOUpqMjdRQUtUVE5hU28KRXVUSzJPcWR3ZnZydGdIODdERTRnWnoyRXdKeTMySXZvVWV4UHZnVGRqbUJvbHErTGQ2Qy9nc3JKVlJHUUNGOQo3ekt5UkZEeDlnNmxKKzZkdGlPOHBRK281WVJoYUlVN1l4V3dJQzZxdkFHeUdQR2dSeDJyWERFaGVJNHhRQjd3Clk2UFBIbzZjQ1hZSjlJTjJoUzhjcTNFYnh2dXo5bk9LbkNBSk54REppVk5lakpQRWVsOUUrb2s2a1J6aTRlZ3UKOVJBPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
    token                  = data.aws_eks_cluster_auth.project-mgmt-eks-cluster-int-2.token
    exec {
      api_version = "client.authentication.k8s.io/v1"
      command     = "aws"
      args = ["eks", "get-token", "--cluster-name", "project-mgmt-eks-cluster-int-2"]    
    }
  }
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

module "kube2iam_2" {
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