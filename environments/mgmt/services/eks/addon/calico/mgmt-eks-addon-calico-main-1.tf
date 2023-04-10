data "aws_eks_cluster_auth" "project-mgmt-eks-cluster-int-test" {
  name = "project-mgmt-eks-cluster-int-test"
}
provider "kubernetes" {  
  alias = "project-mgmt-eks-cluster-int-test"
  host                   = "https://90E75216C189313477479C94FB9B1754.yl4.us-east-2.eks.amazonaws.com"
  cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1EUXhNREEwTURJMU1Wb1hEVE16TURRd056QTBNREkxTVZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTndICnk5Y1pCWHp2Y1BnYi9Za1JZWnk2QkRvbEgxdFBmNXlzNkdtTEZyTFZ0aHB3NUNvQXduamlHakhKemZlMGJxRkYKbFc5WktFcTVUbElrOEticzhKRFZZV2VJSWJndFdjRzcwSnQ1ODRVNVdDTXk3K2VsdWJiSXBoOVhwQ25MMXlZTgoxSDl2ajV2MFVxZUZoMWdOZ0NjMFJwRXkxeTlpNWsrZ2NiRWkzMGlDT0FuWUZoUlZwWFJLeUZvRnU5Q2hEc0xZCmRYSExCdER0cVRKVUsxL0hDYnV4U1lGekloZnZRWXNaRGVqNURpMUVyTkdiVnFaWjRPRGVaenBTOEk2VnZJenEKRldLZWl0VERFRkdPbXBLYWRxeEkxZ2hDYm1UaGhDaEQyYTFTZzRqK3BJRTFxNmUySjVJVzNMSHRZWTFVdFI0UwpWczVDZk5leFJtaDBmaDVHVXlFQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZHMVJkamZzai9iNmE3QVM5S2RqSWRoa3JTLy9NQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBRThTNFJYbkZBWnJONVdrUStXUgpUSTdnN3NtUlFOM0cxeExsbzVGL0dmalhmeFpOVFY0SGRBVTVaem11aWtHcWpiQXBoaGlNRmJTOFNDMWZOcVV5CkU5WEc0NVViSC9ra1QyMGluaDcxWDcreGdublBGTTFqSjdBUklIT2RWR1BkWWNHS2o0bUgxNGlGZVJBSmE3Z3gKVU0xL1Arb1JWOXF2NDdRZi9KN2dBbjRwWWdhMXZuTWkvcFBreFNtVlBUYXViT2xDQi9PbTgxbVNDc3RjMHNRRgpzTFNVSVE2WHBmQjRpUUg5T0Jwb0psbDRoVUZBUG9EUkF6V1hJVjErNENISmRYS0traGNSZ3dPeFh5MUNuVWRGCnB6TndFUmszZzRzSnhKc3Y0dDRHZTB0YkRZcnUzTE5iejVqbDRuMlZYdEpFSThBVzdnMUZnak5oYmFBYmZMd0UKTGZrPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
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
    host                   = "https://90E75216C189313477479C94FB9B1754.yl4.us-east-2.eks.amazonaws.com"
    cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1EUXhNREEwTURJMU1Wb1hEVE16TURRd056QTBNREkxTVZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTndICnk5Y1pCWHp2Y1BnYi9Za1JZWnk2QkRvbEgxdFBmNXlzNkdtTEZyTFZ0aHB3NUNvQXduamlHakhKemZlMGJxRkYKbFc5WktFcTVUbElrOEticzhKRFZZV2VJSWJndFdjRzcwSnQ1ODRVNVdDTXk3K2VsdWJiSXBoOVhwQ25MMXlZTgoxSDl2ajV2MFVxZUZoMWdOZ0NjMFJwRXkxeTlpNWsrZ2NiRWkzMGlDT0FuWUZoUlZwWFJLeUZvRnU5Q2hEc0xZCmRYSExCdER0cVRKVUsxL0hDYnV4U1lGekloZnZRWXNaRGVqNURpMUVyTkdiVnFaWjRPRGVaenBTOEk2VnZJenEKRldLZWl0VERFRkdPbXBLYWRxeEkxZ2hDYm1UaGhDaEQyYTFTZzRqK3BJRTFxNmUySjVJVzNMSHRZWTFVdFI0UwpWczVDZk5leFJtaDBmaDVHVXlFQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZHMVJkamZzai9iNmE3QVM5S2RqSWRoa3JTLy9NQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBRThTNFJYbkZBWnJONVdrUStXUgpUSTdnN3NtUlFOM0cxeExsbzVGL0dmalhmeFpOVFY0SGRBVTVaem11aWtHcWpiQXBoaGlNRmJTOFNDMWZOcVV5CkU5WEc0NVViSC9ra1QyMGluaDcxWDcreGdublBGTTFqSjdBUklIT2RWR1BkWWNHS2o0bUgxNGlGZVJBSmE3Z3gKVU0xL1Arb1JWOXF2NDdRZi9KN2dBbjRwWWdhMXZuTWkvcFBreFNtVlBUYXViT2xDQi9PbTgxbVNDc3RjMHNRRgpzTFNVSVE2WHBmQjRpUUg5T0Jwb0psbDRoVUZBUG9EUkF6V1hJVjErNENISmRYS0traGNSZ3dPeFh5MUNuVWRGCnB6TndFUmszZzRzSnhKc3Y0dDRHZTB0YkRZcnUzTE5iejVqbDRuMlZYdEpFSThBVzdnMUZnak5oYmFBYmZMd0UKTGZrPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
    token                  = data.aws_eks_cluster_auth.project-mgmt-eks-cluster-int-test.token
    exec {
      api_version = "client.authentication.k8s.io/v1"
      command     = "aws"
      args = ["eks", "get-token", "--cluster-name", "project-mgmt-eks-cluster-int-test"]    
    }
  }
}

# resource "null_resource" "create_access_key_file_1" {
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

module "calico_helm_creation_1" {
  source = "../../../../../../modules/services/eks/addon/helm"
  providers = { helm = helm.project-mgmt-eks-cluster-int-test }
  helm_info = local.helm_info[1]    
  helm_module_depends_on = null
}

resource "null_resource" "install_calico_1" {
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
  depends_on = [module.calico_helm_creation_1]
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

module "calico_kubectl_1" {
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