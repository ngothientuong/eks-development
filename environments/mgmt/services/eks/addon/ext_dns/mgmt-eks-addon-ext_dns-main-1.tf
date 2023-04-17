data "aws_eks_cluster_auth" "project-mgmt-eks-cluster-int-test" {
  name = "project-mgmt-eks-cluster-int-test"
}
provider "kubernetes" {  
  alias = "project-mgmt-eks-cluster-int-test"
  host                   = "https://DCE6C39EE8E03B839EF4F8F1DA4672E5.gr7.us-east-2.eks.amazonaws.com"
  cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1EUXhOekE0TXpZME0xb1hEVE16TURReE5EQTRNelkwTTFvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTmh3CjBXT2U0blVaTHNHRTcrQ3hYcmw1aExKcktib1Vsdjl4VGkrWnFwaUhRY21pSHJieWU0RVF4RytPL2ZhaFM3bVEKanZxc0xacFZuUmQ4VDdCL3A5WVhrRlZvU3JRTUhKNWJDVjFvZVJ4RUlISlZteTZSZjJpQTNGK3FCNXhCRDBpawpNTWxNR0RRaDE3V2NxTCsrYUtFbHh6NVdsalc1ZFYwdEVJZnZoWEdvTFV0SWVLWER0TjZqNVRReGxCYWpaMU90Cjd6ZkRZMkU1TWF1dkx2V0pUa2txRGZhcDZ6OEpXY05ZbklwNmVJOFdXd1lTdFV2Uk82QU5uaGZGQUE4cjJLNS8KdUJJZ05oc1VZVHQ5aXdhdURJSzZMT0dBendKVUtmRUxPR080U3I5dkFmZnpkU0Z0UVVlWmxkaU1SUVlqM3lMSQpSV2ZDZzdtTTFVSGp4Zlc3MjBVQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZIWEg2ZkpGdmJUSVZLYWorUzdKUWVRbjlDci9NQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBREtJVzVHMUFRT2FPTnR0TkpGegp3d1A3NUpRR3g1OGRZRm1Vcm51d0pyR3RPQWgrV1ZtQ0dkLzJBYnFXVWZoUTBJdXd4TWdHQ2RnMFg4TERJeVo0CkNxY3dCcDhRNGFHZEo4cUlkT0tvSkw2OEl4QXBDMjNBOUxvWGlrRFJXQnhTM2lGclF4bklhZHBicUt1Y3lIWWMKZGk4WktLbm5UNkNERVdEQVIzOEdsOWhNR3RCRGREVFdUdm9HUnlEbHJmQTJyVmZPeEdqTk5iclZMM1RkSDM3Wgozd0x5RHVEQXY3eFRHZmIySjNxV2NvY3k0TzRsM0pRbTZ4MFo5cWdDeTFmNUUveXNpSjNSWWtRYTk2NHpJZEJOClBjU2kybXp1WWpPTFYwYjJCYVJCaFExZnlGS0N4cFRFb08zaHRYdmJld0dSV1l2UFprYmhEbnJjb2hTV2FzQkgKWis0PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
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
    host                   = "https://DCE6C39EE8E03B839EF4F8F1DA4672E5.gr7.us-east-2.eks.amazonaws.com"
    cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1EUXhOekE0TXpZME0xb1hEVE16TURReE5EQTRNelkwTTFvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTmh3CjBXT2U0blVaTHNHRTcrQ3hYcmw1aExKcktib1Vsdjl4VGkrWnFwaUhRY21pSHJieWU0RVF4RytPL2ZhaFM3bVEKanZxc0xacFZuUmQ4VDdCL3A5WVhrRlZvU3JRTUhKNWJDVjFvZVJ4RUlISlZteTZSZjJpQTNGK3FCNXhCRDBpawpNTWxNR0RRaDE3V2NxTCsrYUtFbHh6NVdsalc1ZFYwdEVJZnZoWEdvTFV0SWVLWER0TjZqNVRReGxCYWpaMU90Cjd6ZkRZMkU1TWF1dkx2V0pUa2txRGZhcDZ6OEpXY05ZbklwNmVJOFdXd1lTdFV2Uk82QU5uaGZGQUE4cjJLNS8KdUJJZ05oc1VZVHQ5aXdhdURJSzZMT0dBendKVUtmRUxPR080U3I5dkFmZnpkU0Z0UVVlWmxkaU1SUVlqM3lMSQpSV2ZDZzdtTTFVSGp4Zlc3MjBVQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZIWEg2ZkpGdmJUSVZLYWorUzdKUWVRbjlDci9NQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBREtJVzVHMUFRT2FPTnR0TkpGegp3d1A3NUpRR3g1OGRZRm1Vcm51d0pyR3RPQWgrV1ZtQ0dkLzJBYnFXVWZoUTBJdXd4TWdHQ2RnMFg4TERJeVo0CkNxY3dCcDhRNGFHZEo4cUlkT0tvSkw2OEl4QXBDMjNBOUxvWGlrRFJXQnhTM2lGclF4bklhZHBicUt1Y3lIWWMKZGk4WktLbm5UNkNERVdEQVIzOEdsOWhNR3RCRGREVFdUdm9HUnlEbHJmQTJyVmZPeEdqTk5iclZMM1RkSDM3Wgozd0x5RHVEQXY3eFRHZmIySjNxV2NvY3k0TzRsM0pRbTZ4MFo5cWdDeTFmNUUveXNpSjNSWWtRYTk2NHpJZEJOClBjU2kybXp1WWpPTFYwYjJCYVJCaFExZnlGS0N4cFRFb08zaHRYdmJld0dSV1l2UFprYmhEbnJjb2hTV2FzQkgKWis0PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
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

module "ext_dns_1" {
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