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

module "aws_pca_issuer_helm_creation_1" {
  source = "../../../../../../../modules/services/eks/addon/helm"
  providers = { helm = helm.project-mgmt-eks-cluster-int-test }
  helm_info = local.helm_info[1]  
  helm_module_depends_on = ""
  #helm_module_depends_on = module.kubectl_apply_1
}