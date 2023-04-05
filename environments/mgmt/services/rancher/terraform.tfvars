project_cidr = "104.0.0.0/16"
env = "mgmt"
ec2_remote_ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8jnUrRWJt/Rvvu0m4Haj0OPu9uGpT8ELSGYIXliCTbt0YJ+P6l/aDmghzx+ppl5PHjq8M448xFo6T3Jf8n5Aqu+rDnAEs86cfHESJ977oRUqzD9h4xNRe1ZUFdmqxPKhe43KSKKsu3KldpcUkQTNZO24rphryIwtGkT2UaNxFKKT+fV9/brmZjR5206cQBkospqK7CzNhm1ziSdgHCubwS14AhzSGNyk32RM4UfQBMFHOONaZR1XXXWz7tYScew5JA8sv33my5+3hYaz2w9ZWGcoWH/cTIz/h/9ptdna5BGdz7IbLvpXEvseVa+isVoXjWYwtxgvTZ8ulswZ6e7kR tngo-keypair"
// bootstrap module
rancher_initial_password = "admin123!admin123!"
// IAM Roles
#iam_role_name = "mgmt-rancher-eks-iam_role_name"
iam_minimum_policy_name = "mgmt-rancher-eks-iam_minimum_policy_name"
service_role_policy = "mgmt-rancher-eks-service_role_policy"
vpc_role_policy = "mgmt-rancher-eks-vpc_role_policy"
eks_service_role_name = "mgmt-rancher-eks-service-role"
additional_iam_policies = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy","arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy","arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy","arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]

// EKS Cluster info
rancher2_aws_credential = "rancher_eks_user_1"
eks_cluster_non_lt_name =  "mgmt-eks-cluster-lt-1"
eks_non_lt_node_group = [
    {
        "name" = "mgmt-eks_cluster_non_lt_ng1"
        "instance_type" = "m5.xlarge"
        "desired_size" = "2"
        "max_size" = "3"        
    }
]
clusters = [
    {
      cluster_name              = "mgmt-eks-cluster-lt-platform"
      description               = "This a cluster for Platform Team - mgmt environment"      
      vpc_id                    = "vpc-03fdd10513a75bc26"
      #cloud_credential_id       = ""
      #region                    = ""
      k8s_kms_key_id = "arn:aws:kms:us-east-2:682331604648:key/41373326-d2fa-4642-9d80-ca2373e14cef"
      secrets_encryption        = true
      eks_security_groups          = ["sg-03ed65527fb9c8ceb"]
      service_role             = "mgmt-rancher-eks-service-role"
      eks_subnets              = ["subnet-01993853122938776","subnet-0434f54e58eba0121"]
      #tags                     = ""      
      enable_cluster_monitoring = false
      eks_version               = "1.24"
      logging_types             = ["audit", "api"]      
      private_access            = true
      public_access             = false
      launch_template = {          
        block_device_mappings =  [
            {
            device_name = "/dev/xvda"
            ebs = {
                delete_on_termination = "true"          
                volume_size = 50
                volume_type = "gp3"
                }           
            }
        ]
        default_version = 1  
        disable_api_stop = false
        disable_api_termination = false
        ebs_optimized = false    
      }
      node_groups = [
        {
          name          = "mgmt_mgmt-platform_ng_1"
          instance_type = "m5.xlarge"
          desired_size  = 3
          max_size      = 5
          disk_size     = 60
          #subnets       = []
          ec2_ssh_key   = "mgmt_platform_ng_1"
          labels = {
            "Team" = "mgmt-platform-ng-1"
          }
          tags = {
            "Name" = "mgmt-platform-kes-node-group-1"
            "Team" = "mgmt-platform-ng-1"
          }
        }
      ]
    },
    {
      cluster_name              = "mgmt-eks-cluster-lt-dev"
      description               = "This a cluster for Dev Team - mgmt environment"      
      vpc_id                    = "vpc-03fdd10513a75bc26"
      #cloud_credential_id       = ""
      #region                    = ""
      k8s_kms_key_id = "arn:aws:kms:us-east-2:682331604648:key/41373326-d2fa-4642-9d80-ca2373e14cef"
      secrets_encryption        = true
      eks_security_groups          = ["sg-03ed65527fb9c8ceb"]
      service_role             = "mgmt-rancher-eks-service-role"
      eks_subnets              = ["subnet-01993853122938776","subnet-0434f54e58eba0121"]
      #tags                     = ""            
      enable_cluster_monitoring = false
      eks_version               = "1.24"
      logging_types             = ["audit", "api"]      
      private_access            = true
      public_access             = false
      launch_template = {          
        block_device_mappings =  [
            {
            device_name = "/dev/xvda"
            ebs = {
                delete_on_termination = "true"          
                volume_size = 50
                volume_type = "gp3"
                }           
            }
        ]  
        default_version = 1  
        disable_api_stop = false
        disable_api_termination = false
        ebs_optimized = false    
      }
      node_groups = [
        {
          name          = "mgmt_dev_ng_1"
          instance_type = "t3.medium"
          desired_size  = 2
          max_size      = 3
          disk_size     = 45
          #subnets       = []
          ec2_ssh_key   = "mgmt_dev_ng_1"
          labels = {
            "Team" = "mgmt-dev-ng-1"
          }
          tags = {
            "Name" = "mgmt-dev-kes-node-group-1"
            "Team" = "mgmt-dev-ng-1"
          }
        },
        {
          name          = "mgmt_dev_ng_2"
          instance_type = "t3.large"
          desired_size  = 2
          max_size      = 3
          disk_size     = 55
          #subnets       = []
          ec2_ssh_key   = "mgmt_dev_ng_2"
          labels = {
            "Team" = "mgmt-dev-ng-2"
          }
          tags = {
            "Name" = "mgmt-dev-kes-node-group-2"
            "Team" = "mgmt-dev-ng-2"
          }
        }                
      ]
    }
]

# k8s_version = "1.24"
# logging_types = []  #["audit", "api"]
# k8s_kms_key_id = "arn:aws:kms:us-east-2:682331604648:key/41373326-d2fa-4642-9d80-ca2373e14cef"
# #eks_service_role_name = "arn:aws:iam::682331604648:role/project-AdminAccess"

# eks_security_groups = ["sg-03ed65527fb9c8ceb"]

aws_ami_name         = "amzn2-ami-hvm-2.0.20220912.1-x86_64-gp2"
aws_instance_profile = "iac-rancher-profile"

// cluster
cluster_kubernetes_version       = "v1.20.15-rancher2-1"
cluster_etcd_instance_type       = "t2.large"
cluster_cp_instance_type         = "t2.large"
cluster_worker_instance_type     = "t2.xlarge"
cluster_worker_asg_instance_type = "t2.xlarge"
