# tngo.tfvars

// Initialization of S3 and dynamododb_table
dynamodb_table_name = "tim-tf-k8s-state"
s3_bucket_name = "tim-tf-k8s-state"

env = "mgmt"
env_lc = "mgmt"
aws_ec2_key_name = "tngo-keypair"

// project
project_id      = "tngo"
project_name    = "tngo"
project_domain  = "bylightsdc.bylight.com"
project_archive = "bl-artifacts"

## MHV
# env = "Management"
# env_lc = "mgmt"
# aws_ec2_key_name = "vaawsmhv"

# project_id      = "mhv"
# project_name    = "MyHealtheVet"
# project_domain  = "va.gov"
# project_archive = "mhv-artifacts"


# EKS Cluster of the environment
clusters = [
    {
      cluster_name              = "project-mgmt-eks-cluster-rancher-test"     
      cluster_env               =  "mgmt"  # From subnet's tags   
      service_ipv4_cidr         = "172.16.0.0/16"  # Must be unique between cluster.    
      iam_console_user_role             = "project-mgmt-rancher"  
      kube2iam_role              = "project-mgmt-rancher"      
      cluster_backup_bucket     = "project-mgmt-rancher-eks-backup"  
      cluster_additional_backup_bucket     = "project-mgmt-rancher-additional-eks-backup"  
      enabled_cluster_log_types = ["audit", "api","authenticator","controllerManager","scheduler"]            
      #k8s_kms_key_arn = "arn:aws:kms:us-east-2:682331604648:key/41373326-d2fa-4642-9d80-ca2373e14cef"      
      eks_version               = "1.26"
      eks_subnets              = ["subnet-06568ba86bee0eefa","subnet-001a39ffe9acc06ee"]
      #eks_subnets              = ["subnet-06568ba86bee0eefa"] # Stick w private subnet 1
      #eks_security_groups          = ["sg-019347f2aa06a38b7"]  # Optional 
      endpoint_private_access = false      
        ### Requirements between LT and NG
        ### https://docs.aws.amazon.com/eks/latest/userguide/launch-templates.html
        # Choose subnet for NG, not LT
        # Choose Node IAM role for NG, not IAM instance profile for LT
        # Do not choose shutdown + stop behavior for LT        
        # AMI: Only choose AMI in NG <=> no Application + OS Images (AMI) specified in LT
        # Do not specified disk size in NG. Replace it by Volumes in LT
        # Do not specify ssh key pair in NG. Put in LT
        # Must enable SG to allow access to the NG for ssh access. Can inherit SG All traffic ingress only from source from EKS control plane
        # Can't specify source security groups in NG when using LT. Specify SG in LT
        # Security group of LT must either be at instance level or network interface level, NOT both
        # EKS applied cluster SG to the NG. If SG added manually to NG, then must configure SG for NG to talk to the end point of the cluster. Wrong step and the NG can't join the EKS cluster.
        # Use TagSpecification paremeter of a LT, not NG.
        # Specify user data in LT. It'll be merged with Amazon EKS user data to join the cluster
        # Supply LT with: 
        # my-cluster, api-server-endpoint, region-code, service-cidr, dns-cluster-ip (ending with 10 from service-cidr), 
        # If using custom AMI ID: Can't specify amiType, releaseVersion, version
        # Amazon EKS optimized Amazon Linux AMIs: Have kubelet, AWS IAM Authenticator, Docker and containerd built in
        # Install awscli for AMI in user data.
        # Assign instance role to NG to query S3 bucket, SSM.
      node_groups = [
        {          
          name          = "project-rancher-mgmt_ng1"                    
          node_group_name_prefix = "project-rancher-mgmt_ng1"
          ng_subnets = ["subnet-06568ba86bee0eefa"]
          desired_size  = 1
          max_size      = 2
          min_size      = 1
          # disk_size     = 100  # Replaced volumes size by LT
          #max_unavailable = 2
          max_unavailable_percentage = 33 
          #ami_type      = "CUSTOM" # Avoid this 
          capacity_type = "ON_DEMAND"
          force_update_version = null          
          labels = {
            "Creator" = "Tuong Ngo"
          }          
          #release_version = null          
          # ec2_ssh_key   = "vaawsmhv" # Replaced by key_name in LT
          tags = {
            "Name" = "project-rancher-mgmt_ng1"
            "Creator" = "Tuong Ngo"
          }
          # taint key and value each has maximun length of 63!
          # taint = [
          #   {
          #     key = "ignore-taint.cluster-autoscaler.kubernetes.io/agent-not-ready"
          #     value = true
          #     effect = "NO_EXECUTE"
          #   }
          # ]
          taint = [{}]
          ng_eks_version = 1.26 
          pre_userdata = ""  
          post_userdata = ""          
          #kubelet_extra_args = "--register-with-taints=\"ignore-taint.cluster-autoscaler.kubernetes.io/cilium-agent-not-ready=true:NoExecute\""      # It works BUT no need for 2 node taints at 2 different place
          kubelet_extra_args = "--register-with-taints=\"node.cilium.io/agent-not-ready=true:NoExecute\""
          bootstrap_extra_args = ""
          lt_config = {
            # name is cluster id + ng name
            description            = "Launch Template for EKS Managed Node Groups"
            update_default_version = true
            custom_ami_id          = "ami-0bc87fc008168cc65" # Do not use custom image_id (or ami) and let EKS choose it for you
            enable_monitoring      = true            
            public_ip              = false
            key_name               = "tngo-keypair"
            instance_type = "m5.2xlarge"
            # SG in LT: Hold off. Let the cluster control it for now
            # EBS Block Device config only used with Launch Templates
            block_device_mappings = [{
                device_name           = "/dev/xvda"  # This is root device!!! Delete on termination is true. For all other, delete_on_termination is default to false
                volume_type           = "gp2" # The volume type. Can be standard, gp2, gp3, io1, io2, sc1 or st1 (Default: gp3).
                volume_size           = 50
                delete_on_termination = true
                encrypted             = true                
                # iops                  = 3000  # Conflict with gp3 volume type
                #throughput            = 125  # Conflict with gp3 volume type
            }]
            core_count                = 4 # 2 for m5.xlarge; [2,4] for m5.2xlarge
            threads_per_core          = 2 # Valid value is [1,2]
            #instance_initiated_shutdown_behavior = "terminated"   # Not allowed to be set here
            ebs_optimized             = true
            disable_api_termination = false
            #default_version = "latest"     
            tag_specifications = {
              resource_type = "instance"
              tags = {
                #"k8s.io/cluster-autoscaler/my-cluster"	= "owned"  # For k8s auto-scaler
                "k8s.io/cluster-autoscaler/enabled" = true    # For k8s-auto scaler
              }
            }
            metadata_options = {
              http_endpoint               = "enabled"
              http_tokens                 = "required"
              http_put_response_hop_limit = 2
              instance_metadata_tags      = "enable"
            }
          }
        }
      ]
    },
    {
      cluster_name              = "project-mgmt-eks-cluster-int-test"       
      cluster_env               =  "int"  # From subnet's tags
      service_ipv4_cidr         = "172.17.0.0/16"  # Must be unique between cluster.    
      iam_console_user_role             = "project-mgmt-int"
      kube2iam_role              = "project-mgmt-int"
      cluster_backup_bucket     = "project-mgmt-int-test-eks-backup"  
      cluster_additional_backup_bucket     = "project-mgmt-int-additional-eks-backup"  
      enabled_cluster_log_types = ["audit", "api","authenticator","controllerManager","scheduler"]      
      #k8s_kms_key_arn = "arn:aws:kms:us-east-2:682331604648:key/41373326-d2fa-4642-9d80-ca2373e14cef"      
      eks_version               = "1.26"
      eks_subnets              = ["subnet-0ba654dee6f07a181","subnet-0826eccf3e4f3e11e"] 
      #eks_security_groups          = ["sg-019347f2aa06a38b7"]  # Optional
      endpoint_private_access = false    
      node_groups = [
        {
          name          = "project-rancher-int_ng1"                    
          node_group_name_prefix = "project-rancher-int_ng1"
          ng_subnets = ["subnet-0ba654dee6f07a181"]
          desired_size  = 1
          max_size      = 2
          min_size      = 1
          #disk_size     = 100            
          #max_unavailable = 2
          max_unavailable_percentage = 33 
          #ami_type      = "CUSTOM" # Avoid this
          capacity_type = "ON_DEMAND"
          force_update_version = null          
          labels = {
            "Creator" = "Tuong Ngo"
          }          
          #release_version = null          
          #ec2_ssh_key   = "vaawsmhv"
          tags = {
            "Name" = "project-rancher-int_ng1"
            "Creator" = "Tuong Ngo"
          }
          # taint key and value each has maximun length of 63!
          # taint = [
          #   {
          #     key = "ignore-taint.cluster-autoscaler.kubernetes.io/agent-not-ready"
          #     value = true
          #     effect = "NO_EXECUTE"
          #   }
          # ]
          taint = [{}]
          ng_eks_version = 1.26 
          pre_userdata = ""  
          post_userdata = ""
          #kubelet_extra_args = "--register-with-taints=\"ignore-taint.cluster-autoscaler.kubernetes.io/cilium-agent-not-ready=true:NoExecute\""      # It works BUT no need for 2 node taints at 2 different place
          kubelet_extra_args = "--register-with-taints=\"node.cilium.io/agent-not-ready=true:NoExecute\""
          bootstrap_extra_args = ""       
          lt_config = {
            # name is cluster id + ng name
            description            = "Launch Template for EKS Managed Node Groups"
            update_default_version = true
            custom_ami_id          = "ami-0bc87fc008168cc65"
            enable_monitoring      = true            
            public_ip              = false
            key_name               = "tngo-keypair"
            instance_type = "m5.xlarge"
            # EBS Block Device config only used with Launch Templates
            block_device_mappings = [{
                device_name           = "/dev/xvda"  # This is root device!!! Delete on termination is true. For all other, delete_on_termination is default to false
                volume_type           = "gp2" # The volume type. Can be standard, gp2, gp3, io1, io2, sc1 or st1 (Default: gp3).
                volume_size           = 50
                delete_on_termination = true
                encrypted             = true                
                # iops                  = 3000  # Conflict with gp3 volume type
                #throughput            = 125  # Conflict with gp3 volume type
            }]
            core_count                = 2
            threads_per_core          = 2  # Valid value is [1,2]
            #instance_initiated_shutdown_behavior = "terminated"   # stop , terminated
            ebs_optimized             = true
            disable_api_termination = false
            #default_version = "latest"     
            tag_specifications = {
              resource_type = "instance"
              tags = {
                #"k8s.io/cluster-autoscaler/my-cluster"	= "owned"  # For k8s auto-scaler
                "k8s.io/cluster-autoscaler/enabled" = true    # For k8s-auto scaler
              }
            }     
            metadata_options = {
              http_endpoint               = "enabled"
              http_tokens                 = "required"
              http_put_response_hop_limit = 2
              instance_metadata_tags      = "enable"
            }        
          }
        }
      ]        
    },
    {
      cluster_name              = "project-mgmt-eks-cluster-int-2"       
      cluster_env               =  "int"  # From subnet's tags
      service_ipv4_cidr         = "172.18.0.0/16"  # Must be unique between cluster.    
      iam_console_user_role             = "project-mgmt-int-2"
      kube2iam_role              = "project-mgmt-int-2"
      cluster_backup_bucket     = "project-mgmt-int-2-eks-backup"  
      cluster_additional_backup_bucket     = "project-mgmt-int-2-additional-eks-backup"  
      enabled_cluster_log_types = ["audit", "api","authenticator","controllerManager","scheduler"]      
      #k8s_kms_key_arn = "arn:aws:kms:us-east-2:682331604648:key/41373326-d2fa-4642-9d80-ca2373e14cef"      
      eks_version               = "1.26"
      eks_subnets              = ["subnet-0ba654dee6f07a181","subnet-0826eccf3e4f3e11e"] 
      #eks_security_groups          = ["sg-019347f2aa06a38b7"]  # Optional
      endpoint_private_access = false    
      node_groups = [        
        {
          name          = "project-rancher-int-2_ng2"                    
          node_group_name_prefix = "project-rancher-int-2_ng2"
          ng_subnets = ["subnet-0826eccf3e4f3e11e"]
          desired_size  = 1
          max_size      = 2
          min_size      = 1
          #disk_size     = 100            
          #max_unavailable = 2
          max_unavailable_percentage = 33 
          #ami_type      = "CUSTOM" # Avoid this
          capacity_type = "ON_DEMAND"
          force_update_version = null          
          labels = {
            "Creator" = "Tuong Ngo"
          }          
          #release_version = null          
          #ec2_ssh_key   = "vaawsmhv"
          tags = {
            "Name" = "project-rancher-int-2_ng2"
            "Creator" = "Tuong Ngo"
          }
          # taint key and value each has maximun length of 63!
          # taint = [
          #   {
          #     key = "ignore-taint.cluster-autoscaler.kubernetes.io/agent-not-ready"
          #     value = true
          #     effect = "NO_EXECUTE"
          #   }
          # ]
          taint = [{}]
          ng_eks_version = 1.26 
          pre_userdata = ""  
          post_userdata = ""
          #kubelet_extra_args = "--register-with-taints=\"ignore-taint.cluster-autoscaler.kubernetes.io/cilium-agent-not-ready=true:NoExecute\""      # It works BUT no need for 2 node taints at 2 different place
          kubelet_extra_args = "--register-with-taints=\"node.cilium.io/agent-not-ready=true:NoExecute\""
          bootstrap_extra_args = ""
          lt_config = {
            # name is cluster id + ng name
            description            = "Launch Template for EKS Managed Node Groups"
            update_default_version = true
            custom_ami_id          = "ami-0bc87fc008168cc65"
            enable_monitoring      = true            
            public_ip              = false
            key_name               = "tngo-keypair"
            instance_type = "m5.xlarge"
            # EBS Block Device config only used with Launch Templates
            block_device_mappings = [{
                device_name           = "/dev/xvda"  # This is root device!!! Delete on termination is true. For all other, delete_on_termination is default to false
                volume_type           = "gp2" # The volume type. Can be standard, gp2, gp3, io1, io2, sc1 or st1 (Default: gp3).
                volume_size           = 75
                delete_on_termination = true
                encrypted             = true                
                # iops                  = 3000  # Conflict with gp3 volume type
                #throughput            = 125  # Conflict with gp3 volume type
            }]
            core_count                = 2
            threads_per_core          = 2  # Valid value is [1,2]
            #instance_initiated_shutdown_behavior = "terminated"   # stop , terminated
            ebs_optimized             = true
            disable_api_termination = false
            #default_version = "latest"     
            tag_specifications = {
              resource_type = "instance"
              tags = {
                #"k8s.io/cluster-autoscaler/my-cluster"	= "owned"  # For k8s auto-scaler
                "k8s.io/cluster-autoscaler/enabled" = true    # For k8s-auto scaler
              }
            }
            metadata_options = {
              http_endpoint               = "enabled"
              http_tokens                 = "required"
              http_put_response_hop_limit = 2
              instance_metadata_tags      = "enable"
            }             
          }
        },
      ]        
    }
]
