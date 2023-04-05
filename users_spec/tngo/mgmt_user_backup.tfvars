# tngo.tfvars

// Initialization of S3 and dynamododb_table
dynamodb_table_name = "tim-tf-k8s-state"
s3_bucket_name = "tim-tf-k8s-state"

env = "mgmt"
env_lc = "mgmt"
aws_ec2_key_name = "tngo-keypair"

// project
project_id      = "jw"
project_name    = "jw"
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
      enabled_cluster_log_types = ["audit", "api","authenticator","controllerManager","scheduler"]            
      #k8s_kms_key_arn = "arn:aws:kms:us-east-2:682331604648:key/41373326-d2fa-4642-9d80-ca2373e14cef"      
      eks_version               = "1.25"
      eks_subnets              = ["subnet-0f7f6f51842d20f5f","subnet-0773e5e4b1b14f717"]      
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
        # Must enable SG to allow access to the NG for ssh access. Can inherit SG All traffic ingress from EKS control plane
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
          desired_size  = 3
          max_size      = 5
          min_size      = 3
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
          taint = [{}]
          ng_eks_version = 1.25 
          pre_userdata = ""  
          post_userdata = ""          
          kubelet_extra_args = ""
          bootstrap_extra_args = ""
          lt_config = {
            # name is cluster id + ng name
            description            = "Launch Template for EKS Managed Node Groups"
            update_default_version = true
            custom_ami_id          = "ami-028251eabda9afee5" # Do not use custom image_id (or ami) and let EKS choose it for you
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
      enabled_cluster_log_types = ["audit", "api","authenticator","controllerManager","scheduler"]      
      #k8s_kms_key_arn = "arn:aws:kms:us-east-2:682331604648:key/41373326-d2fa-4642-9d80-ca2373e14cef"      
      eks_version               = "1.25"
      eks_subnets              = ["subnet-0c93838cef57b3142","subnet-0413b18f5f91a429a"] 
      #eks_security_groups          = ["sg-019347f2aa06a38b7"]  # Optional
      endpoint_private_access = false    
      node_groups = [
        {
          name          = "project-rancher-int_ng1"                    
          node_group_name_prefix = "project-rancher-int_ng1"
          desired_size  = 3
          max_size      = 5
          min_size      = 3
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
          taint = [{}]
          ng_eks_version = 1.25 
          pre_userdata = ""  
          post_userdata = ""
          kubelet_extra_args = ""   
          bootstrap_extra_args = ""       
          lt_config = {
            # name is cluster id + ng name
            description            = "Launch Template for EKS Managed Node Groups"
            update_default_version = true
            custom_ami_id          = "ami-028251eabda9afee5"
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
        },
        {
          name          = "project-rancher-int_ng2"                    
          node_group_name_prefix = "project-rancher-int_ng2"
          desired_size  = 3
          max_size      = 5
          min_size      = 3
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
            "Name" = "project-rancher-int_ng2"
            "Creator" = "Tuong Ngo"
          }
          taint = [{}]
          ng_eks_version = 1.25 
          pre_userdata = ""  
          post_userdata = ""
          kubelet_extra_args = ""
          bootstrap_extra_args = ""
          lt_config = {
            # name is cluster id + ng name
            description            = "Launch Template for EKS Managed Node Groups"
            update_default_version = true
            custom_ami_id          = "ami-028251eabda9afee5"
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
        }
      ]        
    }
]

/*
    ########################################################
    # tngo-mgmt - cluster
    ########################################################
    terraform state rm rancher2_cluster.c_mgmt
    terraform state rm rancher2_cluster_sync.c_mgmt
    terraform state rm data.template_file.c_mgmt_etcd
    terraform state rm rancher2_node_template.c_mgmt_etcd
    terraform state rm rancher2_node_pool.c_mgmt_etcd
    terraform state rm data.template_file.c_mgmt_control_plane
    terraform state rm rancher2_node_template.c_mgmt_control_plane
    terraform state rm rancher2_node_pool.c_mgmt_control_plane
    terraform state rm data.template_file.c_mgmt_worker
    terraform state rm rancher2_node_template.c_mgmt_worker
    terraform state rm rancher2_node_pool.c_mgmt_worker
    terraform state rm data.template_file.c_mgmt_worker_asg
    terraform state rm aws_launch_configuration.c_mgmt_worker_asg
    terraform state rm aws_autoscaling_group.c_mgmt_worker_asg
    terraform state rm rancher2_storage_class_v2.c_mgmt_aws_ebs
    terraform state rm rancher2_cluster_logging.c_mgmt
    terraform state rm rancher2_notifier.c_mgmt_email
    terraform state rm rancher2_notifier.c_mgmt_slack
    terraform state rm rancher2_notifier.c_mgmt_msteams

    # projects

    // default
    terraform state rm rancher2_project.c_mgmt_default
    terraform state rm rancher2_certificate.c_mgmt_default
    terraform state rm rancher2_registry.c_mgmt_default
    terraform state rm rancher2_project_logging.c_mgmt_logging
    terraform state rm rancher2_namespace.c_mgmt_default_efs_provisioner
    terraform state rm rancher2_app.c_mgmt_default_efs_provisioner

    // secrets
    terraform state rm rancher2_project.c_mgmt_secrets
    terraform state rm rancher2_certificate.c_mgmt_secrets
    terraform state rm rancher2_namespace.c_mgmt_secrets_consul
    terraform state rm rancher2_namespace.c_mgmt_secrets_vault
    terraform state rm rancher2_app.c_mgmt_secrets_consul
    terraform state rm rancher2_app.c_mgmt_secrets_vault
    terraform state rm rancher2_project_alert_group.c_mgmt_secrets
    terraform state rm rancher2_project_alert_rule.c_mgmt_secrets_vault_workload_less_than_100_percent
    terraform state rm rancher2_project_alert_rule.c_mgmt_secrets_vault_workload_less_than_50_percent
    terraform state rm rancher2_pod_security_policy_template.c_mgmt_secrets_consul

    // twistlock
    terraform state rm rancher2_project.c_mgmt_twistlock
    terraform state rm rancher2_namespace.c_mgmt_twistlock
    terraform state rm rancher2_namespace.c_mgmt_twistlock_defender
    terraform state rm rancher2_app.c_mgmt_twistlock_defender
    terraform state rm rancher2_pod_security_policy_template.c_mgmt_twistlock

    // system
    terraform state rm rancher2_project.c_mgmt_system
    terraform state rm rancher2_namespace.c_mgmt_system_cluster_autoscaler
    terraform state rm rancher2_app.c_mgmt_system_cluster_autoscaler

    ########################################################
    # tngo-int - cluster
    ########################################################

    # cluster
    terraform state rm rancher2_cluster.c_int
    terraform state rm rancher2_cluster_sync.c_int
    terraform state rm data.template_file.c_int_etcd
    terraform state rm rancher2_node_template.c_int_etcd
    terraform state rm rancher2_node_pool.c_int_etcd
    terraform state rm data.template_file.c_int_control_plane
    terraform state rm rancher2_node_template.c_int_control_plane
    terraform state rm rancher2_node_pool.c_int_control_plane
    terraform state rm data.template_file.c_int_worker
    terraform state rm rancher2_node_template.c_int_worker
    terraform state rm rancher2_node_pool.c_int_worker
    terraform state rm data.template_file.c_int_worker_asg
    terraform state rm aws_launch_configuration.c_int_worker_asg
    terraform state rm aws_autoscaling_group.c_int_worker_asg
    terraform state rm rancher2_storage_class_v2.c_int_aws_ebs
    terraform state rm rancher2_cluster_logging.c_int
    terraform state rm rancher2_notifier.c_int_email
    terraform state rm rancher2_notifier.c_int_slack
    terraform state rm rancher2_notifier.c_int_msteams

    # projects

    // default
    terraform state rm rancher2_project.c_int_default
    terraform state rm rancher2_certificate.c_int_default
    terraform state rm rancher2_registry.c_int_default
    terraform state rm rancher2_project_logging.c_int_logging
    terraform state rm rancher2_namespace.c_int_default_efs_provisioner
    terraform state rm rancher2_app.c_int_default_efs_provisioner

    // secrets
    terraform state rm rancher2_project.c_int_secrets
    terraform state rm rancher2_certificate.c_int_secrets
    terraform state rm rancher2_namespace.c_int_secrets_consul
    terraform state rm rancher2_namespace.c_int_secrets_vault
    terraform state rm rancher2_app.c_int_secrets_consul
    terraform state rm rancher2_app.c_int_secrets_vault
    terraform state rm rancher2_project_alert_group.c_int_secrets
    terraform state rm rancher2_project_alert_rule.c_int_secrets_vault_workload_less_than_100_percent
    terraform state rm rancher2_project_alert_rule.c_int_secrets_vault_workload_less_than_50_percent
    terraform state rm rancher2_pod_security_policy_template.c_int_secrets_consul

    // twistlock
    terraform state rm rancher2_project.c_int_twistlock
    terraform state rm rancher2_namespace.c_int_twistlock
    terraform state rm rancher2_namespace.c_int_twistlock_defender
    terraform state rm rancher2_app.c_int_twistlock_defender
    terraform state rm rancher2_pod_security_policy_template.c_int_twistlock

    // system
    terraform state rm rancher2_project.c_int_system
    terraform state rm rancher2_namespace.c_int_system_cluster_autoscaler
    terraform state rm rancher2_app.c_int_system_cluster_autoscaler

    ########################################################
    # tngo-prod - cluster
    ########################################################

    # cluster
    terraform state rm rancher2_cluster.c_prod
    terraform state rm rancher2_cluster_sync.c_prod
    terraform state rm data.template_file.c_prod_etcd
    terraform state rm rancher2_node_template.c_prod_etcd
    terraform state rm rancher2_node_pool.c_prod_etcd
    terraform state rm data.template_file.c_prod_control_plane
    terraform state rm rancher2_node_template.c_prod_control_plane
    terraform state rm rancher2_node_pool.c_prod_control_plane
    terraform state rm data.template_file.c_prod_worker
    terraform state rm rancher2_node_template.c_prod_worker
    terraform state rm rancher2_node_pool.c_prod_worker
    terraform state rm data.template_file.c_prod_worker_asg
    terraform state rm aws_launch_configuration.c_prod_worker_asg
    terraform state rm aws_autoscaling_group.c_prod_worker_asg
    terraform state rm rancher2_storage_class_v2.c_prod_aws_ebs
    terraform state rm rancher2_cluster_logging.c_prod
    terraform state rm rancher2_notifier.c_prod_email
    terraform state rm rancher2_notifier.c_prod_slack
    terraform state rm rancher2_notifier.c_prod_msteams

    # projects

    // default
    terraform state rm rancher2_project.c_prod_default
    terraform state rm rancher2_certificate.c_prod_default
    terraform state rm rancher2_registry.c_prod_default
    terraform state rm rancher2_project_logging.c_prod_logging
    terraform state rm rancher2_namespace.c_prod_default_efs_provisioner
    terraform state rm rancher2_app.c_prod_default_efs_provisioner

    // secrets
    terraform state rm rancher2_project.c_prod_secrets
    terraform state rm rancher2_certificate.c_prod_secrets
    terraform state rm rancher2_namespace.c_prod_secrets_consul
    terraform state rm rancher2_namespace.c_prod_secrets_vault
    terraform state rm rancher2_app.c_prod_secrets_consul
    terraform state rm rancher2_app.c_prod_secrets_vault
    terraform state rm rancher2_project_alert_group.c_prod_secrets
    terraform state rm rancher2_project_alert_rule.c_prod_secrets_vault_workload_less_than_100_percent
    terraform state rm rancher2_project_alert_rule.c_prod_secrets_vault_workload_less_than_50_percent
    terraform state rm rancher2_pod_security_policy_template.c_prod_secrets_consul

    // twistlock
    terraform state rm rancher2_project.c_prod_twistlock
    terraform state rm rancher2_namespace.c_prod_twistlock
    terraform state rm rancher2_namespace.c_prod_twistlock_defender
    terraform state rm rancher2_app.c_prod_twistlock_defender
    terraform state rm rancher2_pod_security_policy_template.c_prod_twistlock

    // system
    terraform state rm rancher2_project.c_prod_system
    terraform state rm rancher2_namespace.c_prod_system_cluster_autoscaler
    terraform state rm rancher2_app.c_prod_system_cluster_autoscaler

## Command Reference

    # view senstive variables
    terraform output project_id
    terraform output project_domain
    terraform output rancher_username
    terraform output rancher_password
    terraform output cluster_kubernetes_version
    terraform output cluster_etcd_instance_type
    terraform output cluster_cp_instance_type
    terraform output cluster_worker_instance_type
    terraform output cluster_worker_asg_instance_type
    terraform output docker_registry_username
    terraform output docker_registry_password
    terraform output dockerhub_registry_username
    terraform output dockerhub_registry_password
    terraform output helm_catalog_username
    terraform output helm_catalog_password
    terraform output elasticsearch_username
    terraform output elasticsearch_password

    # enable debugging
    export TF_LOG_PATH=./terraform.log
    export TF_LOG=TRACE

    # challenge - initialize plan apply
    terraform init
    terraform refresh
    terraform plan -out=c.tfplan
    terraform show c.tfplan
    terraform apply c.tfplan

    refactor: https://learn.hashicorp.com/tutorials/terraform/organize-configuration?in=terraform/modules

    # reset admin password
    docker exec -ti <rancher_container_id> reset-password

    # debug
    https://www.terraform.io/docs/internals/debugging.html
    set TF_LOG_PATH to a file name
    TF_LOG=TRACE terraform refresh -var-file=vars/challenge.tfvars

    cd rancher;
    terraform init -backend-config=vars/challenge-backend.hcl
    terraform refresh -var-file=vars/challenge.tfvars
    terraform plan -lock=false -var-file=vars/challenge.tfvars -out=plans/challenge.tfplan
    terraform show plans/challenge.tfplan
    terraform apply -lock=false plans/challenge.tfplan

*/
