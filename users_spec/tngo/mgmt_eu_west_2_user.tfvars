# tngo.tfvars

// Initialization of S3 and dynamododb_table
dynamodb_table_name = "tim-tf-k8s-state-eu"
s3_bucket_name = "tim-tf-k8s-state-eu"

env = "eumgmt"
env_lc = "eumgmt"
aws_ec2_key_name = "tngo-keypair"

// project
project_id      = "tngo"
project_name    = "tngo"
project_domain  = "bylightsdc.bylight.com"
project_archive = "bl-artifacts"


aws_region = "eu-west-2"

vpc = {
    name = "tngo-eumgmt-eu"
    vpc_cidr = "110.0.0.0/16"
    azs             = ["eu-west-2a", "eu-west-2b"]
    private_subnets = ["110.0.1.0/24", "110.0.3.0/24"]
    private_subnet_names = ["tngo-eumgmt-private-subnet-1","tngo-eumgmt-private-subnet-2"]
    private_subnet_assign_ipv6_address_on_creation = false
    private_subnet_enable_resource_name_dns_aaaa_record_on_launch = false
    private_subnet_tags = { Name = "tngo-eumgmt-private" }
    public_subnets = ["110.0.0.0/24", "110.0.2.0/24"]
    public_subnet_names = ["tngo-eumgmt-public-subnet-1","tngo-eumgmt-public-subnet-2"]
    public_subnet_tags = { Name = "tngo-eumgmt-public" }
    public_subnet_assign_ipv6_address_on_creation = false
    public_subnet_enable_resource_name_dns_aaaa_record_on_launch = false
    enable_nat_gateway = true
    single_nat_gateway = true
    one_nat_gateway_per_az = false
    enable_vpn_gateway = true
    enable_ipv6        = false    
    private_subnet_enable_dns64 = false
    public_subnet_enable_dns64 = false
    tags = {
        Group = "eumgmt"
        Name = "tngo-eumgmt"
        Project = "tngo"
        VPC = "tngo-eumgmt"
    }
}
tgw = {
    name = "tngo-eumgmt-tgw"
    description     = "My TGW peered with other AWS TGW from other region"
    amazon_side_asn = 64513
    enable_auto_accept_shared_attachments  = true
    ## Disable the next 2 attribute so we can use custom TGW Route Table
    enable_default_route_table_association = false
    enable_default_route_table_propagation = false
    enable_mutlicast_support = true
    ram_allow_external_principals = false
    tags = {
        Group = "eumgmt"
        Name = "tngo-eumgmt-tgwa"
        Project = "tngo"
        VPC = "tngo-eumgmt"
    }
}

vpc_sg = {
    name = "eumgmt-default-sg"
    description = "Default VPC SG for eumgmt eu-west-2"
    create = true
    #ingress_cidr_blocks = ["0.0.0.0/0"]
    #ingress_rules            = ["all-all"]  # ["https-443-tcp","ssh-tcp"]
    ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"      
      cidr_blocks = "103.0.0.0/16"
    },
    {
      rule        = "ssh-tcp"
      cidr_blocks = "104.0.0.0/16"
    },
    {
      rule        = "ssh-tcp"
      cidr_blocks = "105.0.0.0/16"
    },
    {
      rule        = "ssh-tcp"
      cidr_blocks = "111.0.0.0/16"
    },
    {
      rule        = "ssh-tcp"
      cidr_blocks = "112.0.0.0/16"
    },
    {
      rule        = "ssh-tcp"
      cidr_blocks = "113.0.0.0/16"
    },
    {
      rule        = "ssh-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = -1

      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 0
      to_port     = 255
      protocol    = "icmp"
      description = "ICMP Protocol"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
    
    egress_with_cidr_blocks = [ 
    {
      from_port   = -1
      to_port     = -1
      protocol    = -1

      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
### EKS Cluster of the environment
clusters = [
    {
      cluster_name              = "project-eumgmt-eks-eu-west-2"     
      cluster_env               =  "eumgmt"  # From subnet's tags   
      service_ipv4_cidr         = "172.20.0.0/16"  # Must be unique between cluster.    
      iam_console_user_role             = "project-eumgmt-eu-west-2"  
      kube2iam_role              = "project-eumgmt-eu-west-2"      
      cluster_backup_bucket     = "project-eumgmt-eu-west-2-eks-backup"  
      cluster_additional_backup_bucket     = "project-eumgmt-eu-west-2-additional-eks-backup"  
      enabled_cluster_log_types = ["audit", "api","authenticator","controllerManager","scheduler"]            
      #k8s_kms_key_arn = "arn:aws:kms:us-east-2:682331604648:key/41373326-d2fa-4642-9d80-ca2373e14cef"      
      eks_version               = "1.26"
      eks_subnets              = ["subnet-091b716d67a1cb564","subnet-09f7de6b8269def0f"]
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
          name          = "project-eu-west-2-eumgmt_ng1"                    
          node_group_name_prefix = "project-eu-west-2-eumgmt_ng1"
          ng_subnets = ["subnet-09f7de6b8269def0f"]
          desired_size  = 1
          max_size      = 5
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
            "Name" = "project-eu-west-2-eumgmt_ng1"
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
          taint=[{}]
          ng_eks_version = 1.26 
          pre_userdata = ""  
          post_userdata = ""          
          #kubelet_extra_args = "--register-with-taints=\"ignore-taint.cluster-autoscaler.kubernetes.io/cilium-agent-not-ready=true:NoExecute\""      # It works BUT no need for 2 node taints at 2 different place
          kubelet_extra_args = ""
          bootstrap_extra_args = ""
          lt_config = {
            # name is cluster id + ng name
            description            = "Launch Template for EKS Managed Node Groups"
            update_default_version = true
            custom_ami_id          = "ami-08574fa0a78c9eede" # Do not use custom image_id (or ami) and let EKS choose it for you
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
]
