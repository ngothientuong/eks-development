data "aws_eks_cluster_auth" "project-mgmt-eks-cluster-rancher-test" {
  name = "project-mgmt-eks-cluster-rancher-test"
}
provider "kubernetes" {  
  alias = "project-mgmt-eks-cluster-rancher-test"
  host                   = "https://EE00B7C37FBEFD736D4DCB89D9BF09D7.sk1.us-east-2.eks.amazonaws.com"
  cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1EUXhNakEzTWpnek1Gb1hEVE16TURRd09UQTNNamd6TUZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTVNKCmwrWktINjYyeEVnU1FyRkVHaGttYUpTMW8zV1RzZk1hQUxndlQ2dVpKR2R6UytRSHlYRUpGWFJrOHZ2VGw3bWMKaUJiTlhoRjR3QmdvQUNRdW10MG51YmMvcURFZ3k4K3YvRTJRbzJmT3U0ME40SjNQbFpNWGJKejUxM25hazJORwo4QVlJbW53bHp2cGVCQ2RZZVJBc0NKQnR3bWxDUHl4SXBUZGpHZGk4NGFaYzJzWjBKbE9tR0lZbFNOekcyek5lClczd1RUcWx1QUM3YXBXL2NKQ2prRlAzWU96Nnk5RzB2aGoxczBCYUdYY0FLdEhuZ3diVnBBeGR1bXZhSmdNdHkKSTJuWEtoclh0M2lOQ0VUN2Uza1hJT0xKeEw5WVM0ZnpDSFZiUHpwTzQyVVI0TmN2eWE3TGxNcDFnSkdsSWhIRgpHbVlxMG5YS3kwZ2x5QTE0RzBFQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZPSlBQZmZ1ZUt6YXNCMlM0RUVrcHhpUDVZQmRNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBQWN3b0ZCajQyZWJQRWdaVlN5UApoZDZFT1ZkQWhVbHZxVmphSktaakEyZnpJYldCT25POXNDQzVtcERuNU01QmpoUWFQTVZsWVROOTI1a3d1WHBsCkYyc1dpV1hzZjhtbFd3QWtqSis0cmFiQ3hEYnc3Q0pJTXdyV0xmeVJlNTZuOFh2bmVBNjZQM2cyZnRlMHRrajYKSjc5d1ZCZm5hSk5DZWdpenhqVmxjRExQNGk4bERhVFVZSkR4S0JHamI2b05xMVdCeFJrMU9XMmZWT1RJZGozOQplM1ZtdC9XSnJIdFVkbytZUlAwdzROMkdqYkpZK0NJMzR3YlpQOGRFWHl0ZmdBYkRyUmNXTDdBSmdvZHZlc2ROClZxNDNIMjBGcTEyTkloeUVsSHI4OHlUMmZwcysvcnhiUk01bnVWcXZTazhMc2NpdkIwUkFRRDNUTTRxTUsyZlYKckprPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
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
    host                   = "https://EE00B7C37FBEFD736D4DCB89D9BF09D7.sk1.us-east-2.eks.amazonaws.com"
    cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1EUXhNakEzTWpnek1Gb1hEVE16TURRd09UQTNNamd6TUZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTVNKCmwrWktINjYyeEVnU1FyRkVHaGttYUpTMW8zV1RzZk1hQUxndlQ2dVpKR2R6UytRSHlYRUpGWFJrOHZ2VGw3bWMKaUJiTlhoRjR3QmdvQUNRdW10MG51YmMvcURFZ3k4K3YvRTJRbzJmT3U0ME40SjNQbFpNWGJKejUxM25hazJORwo4QVlJbW53bHp2cGVCQ2RZZVJBc0NKQnR3bWxDUHl4SXBUZGpHZGk4NGFaYzJzWjBKbE9tR0lZbFNOekcyek5lClczd1RUcWx1QUM3YXBXL2NKQ2prRlAzWU96Nnk5RzB2aGoxczBCYUdYY0FLdEhuZ3diVnBBeGR1bXZhSmdNdHkKSTJuWEtoclh0M2lOQ0VUN2Uza1hJT0xKeEw5WVM0ZnpDSFZiUHpwTzQyVVI0TmN2eWE3TGxNcDFnSkdsSWhIRgpHbVlxMG5YS3kwZ2x5QTE0RzBFQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZPSlBQZmZ1ZUt6YXNCMlM0RUVrcHhpUDVZQmRNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBQWN3b0ZCajQyZWJQRWdaVlN5UApoZDZFT1ZkQWhVbHZxVmphSktaakEyZnpJYldCT25POXNDQzVtcERuNU01QmpoUWFQTVZsWVROOTI1a3d1WHBsCkYyc1dpV1hzZjhtbFd3QWtqSis0cmFiQ3hEYnc3Q0pJTXdyV0xmeVJlNTZuOFh2bmVBNjZQM2cyZnRlMHRrajYKSjc5d1ZCZm5hSk5DZWdpenhqVmxjRExQNGk4bERhVFVZSkR4S0JHamI2b05xMVdCeFJrMU9XMmZWT1RJZGozOQplM1ZtdC9XSnJIdFVkbytZUlAwdzROMkdqYkpZK0NJMzR3YlpQOGRFWHl0ZmdBYkRyUmNXTDdBSmdvZHZlc2ROClZxNDNIMjBGcTEyTkloeUVsSHI4OHlUMmZwcysvcnhiUk01bnVWcXZTazhMc2NpdkIwUkFRRDNUTTRxTUsyZlYKckprPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
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
    command     = "echo \"0\" > ~/module_count"
  }
}

module "ext_snapshotter_0" {
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