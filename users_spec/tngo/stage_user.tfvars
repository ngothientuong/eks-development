# tngo.tfvars

// Initialization of S3 and dynamododb_table
dynamodb_table_name = "tim-tf-k8s-state"
s3_bucket_name = "tim-tf-k8s-state"

env = "Stage"

// project
project_id      = "tngo"
project_name    = "MyHealtheVet"
project_domain  = "va.gov"
project_archive = "bl-artifacts"

user_state      = "global/tngo" 

// aws
aws_region = "us-gov-west-1"
//aws_access_key = "TF_VAR_aws_access_key"
//aws_secret_key = "TF_VAR_aws_secret_key"
aws_ec2_key_name     = "tngo-keypair"
aws_ami_name         = "amzn2-ami-hvm-2.0.20220912.1-x86_64-gp2"
aws_instance_profile = "iac-rancher-profile"

// rancher
rancher_url = "https://rancher-ha-tngo-mgmt.bylightsdc.bylight.com" 
//rancher_username = "{aws_ssm_parameter:/tngo/rancher/admin/account/username}"
//rancher_password = "{aws_ssm_parameter:/tngo/rancher/admin/account/password}" 

// cluster
cluster_kubernetes_version       = "v1.20.15-rancher2-1"
cluster_etcd_instance_type       = "t2.large"
cluster_cp_instance_type         = "t2.large"
cluster_worker_instance_type     = "t2.xlarge"
cluster_worker_asg_instance_type = "t2.xlarge"

// docker hub
dockerhub_registry_url = "https://registry-1.docker.io"
//dockerhub_registry_username = "{aws_ssm_parameter:/tngo/dockerhub/registry/proxy/service/account/username}"
//dockerhub_registry_password = "{aws_ssm_parameter:/tngo/dockerhub/registry/proxy/service/account/password}"

// docker (local)
docker_registry_url = "https://docker-group-tngo-mgmt.bylightsdc.bylight.com"
//docker_registry_username = "{aws_ssm_parameter:/tngo/docker/registry/service/account/username}"
//docker_registry_password = "{aws_ssm_parameter:/tngo/docker/registry/service/account/password}"

// helm catalog
helm_catalog_url = "https://helm-tngo-mgmt.bylightsdc.bylight.com/repository/helm-local"
//helm_catalog_username = "{aws_ssm_parameter:/tngo/helm/service/account/username}"
//helm_catalog_password = "{aws_ssm_parameter:/tngo/helm/service/account/password}"

// elasticsearch
elasticsearch_url = "http://logging-tngo-mgmt.bylightsdc.bylight.com:9200" #modify to push through LB
//elasticsearch_username = "{aws_ssm_parameter:/tngo/elasticsearch/service/account/username}"
//elasticsearch_password = "{aws_ssm_parameter:/tngo/elasticsearch/service/account/password}"

// logstash
logstash_url = "http://logging-tngo-mgmt.bylightsdc.bylight.com:5400"


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
