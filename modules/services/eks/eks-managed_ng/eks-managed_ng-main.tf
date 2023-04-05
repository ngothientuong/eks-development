terraform {
  required_version = ">= 1.3.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.37.0"
    }

    template = {
      source  = "hashicorp/template"
      version = ">=2.2.0"
    }

    null = {
      source  = "hashicorp/null"
      version = ">=3.1.1"
    }
  }
}

########################################################
# providers                                            #
########################################################

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  #access_key = "ASIAZ5XRCA2UGLQ477SO"
  #secret_key = "anmmawhZ4qDujyO9NMKRbxJ2FGl88MqUXmwEG/yy"
  #token      = ""
  # assume_role {    
  #   role_arn    = "arn:aws:iam::682331604648:role/project/project-eks-node-group-ng_role"    
  #   session_name = "assume-role-${formatdate("MMM-DD-YYYY", timestamp())}"
  # }
}

###########################
# Local variables         #
###########################
locals {
  userdata_params = flatten([
  for each_mn_cntxt in var.managed_ng_contexts: [{  
    eks_cluster_id         = each_mn_cntxt.eks_cluster_id == null ? " " : each_mn_cntxt.eks_cluster_id
    cluster_ca_base64      = each_mn_cntxt.cluster_ca_base64 == null ? " " : each_mn_cntxt.cluster_ca_base64
    cluster_endpoint       = each_mn_cntxt.cluster_endpoint == null ? " " : each_mn_cntxt.cluster_endpoint
    custom_ami_id          = each_mn_cntxt.lt_config.custom_ami_id == null ? " " : each_mn_cntxt.lt_config.custom_ami_id
    pre_userdata           = each_mn_cntxt.pre_userdata  == null ? " " :  each_mn_cntxt.pre_userdata     # Applied to all launch templates
    bootstrap_extra_args   = each_mn_cntxt.bootstrap_extra_args == null ? " " : each_mn_cntxt.bootstrap_extra_args # used only when custom_ami_id specified e.g., bootstrap_extra_args="--use-max-pods false --container-runtime containerd"
    post_userdata          = each_mn_cntxt.post_userdata == null ? " " : each_mn_cntxt.post_userdata        # used only when custom_ami_id specified
    kubelet_extra_args     = each_mn_cntxt.kubelet_extra_args == null ? " " : each_mn_cntxt.kubelet_extra_args   # used only when custom_ami_id specified e.g., kubelet_extra_args="--node-labels=arch=x86,WorkerType=SPOT --max-pods=50 --register-with-taints=spot=true:NoSchedule"  # Equivalent to k8s_labels used in managed node groups
    service_ipv6_cidr      = each_mn_cntxt.service_ipv6_cidr == null ? " " : each_mn_cntxt.service_ipv6_cidr
    service_ipv4_cidr      = each_mn_cntxt.service_ipv4_cidr == null ? " " : each_mn_cntxt.service_ipv4_cidr
    format_mount_nvme_disk = true
    s3_artifact            = each_mn_cntxt.s3_artifact == null ? " " : each_mn_cntxt.s3_artifact
    project_id                 = each_mn_cntxt.project_id == null ? " " : each_mn_cntxt.project_id
    aws_region                 = each_mn_cntxt.aws_region == null ? " " : each_mn_cntxt.aws_region
  }
  ]])
}

########################################################
# Launch Template                                      #
########################################################

resource "aws_launch_template" "lt_mn_ng" {
  count = length(var.managed_ng_contexts) > 0 ? length(var.managed_ng_contexts) : 0
  #count = 0

  name_prefix                   = "${var.managed_ng_contexts[count.index].node_group_name_prefix}"
  description            = "${format("%s%s","Launch Template for ",var.managed_ng_contexts[count.index].node_group_name_prefix)}"
  update_default_version = "${var.managed_ng_contexts[count.index].lt_config.update_default_version}"
  monitoring {
    enabled = "${var.managed_ng_contexts[count.index].lt_config.enable_monitoring}"
  }
  
  network_interfaces {
    associate_public_ip_address = "${var.managed_ng_contexts[count.index].lt_config.public_ip}"
    security_groups = [replace(var.managed_ng_contexts[count.index].eks_security_group_id,"\"",""),replace(var.managed_ng_contexts[count.index].cluster_security_group_id,"\"","")]
    ipv4_prefixes = ["10.0.0.0/8","172.0.0.0/8","192.0.0.0/8"]
    
  }

  key_name = "${var.managed_ng_contexts[count.index].lt_config.key_name}"
  instance_type = "${var.managed_ng_contexts[count.index].lt_config.instance_type}"
  dynamic "block_device_mappings" {
    for_each = "${var.managed_ng_contexts[count.index].lt_config.block_device_mappings}"

    content {
      device_name = try(block_device_mappings.value.device_name, null)

      ebs {
        delete_on_termination = try(block_device_mappings.value.delete_on_termination, true)
        encrypted             = try(block_device_mappings.value.encrypted, true)
        kms_key_id            = var.k8s_kms_key_arn
        volume_size           = try(block_device_mappings.value.volume_size, null)
        volume_type           = try(block_device_mappings.value.value.volume_type, null)
        #iops                  = try(block_device_mappings.value.iops, null)  # Conflict with GP3 volume type
        #throughput            = try(block_device_mappings.value.throughput, null)  # Conflict with GP3 volume type
      }
    }
  }
  cpu_options {
    core_count       = "${var.managed_ng_contexts[count.index].lt_config.core_count}"
    threads_per_core = "${var.managed_ng_contexts[count.index].lt_config.threads_per_core}"
  }
  ebs_optimized = "${var.managed_ng_contexts[count.index].lt_config.ebs_optimized}"
  image_id = "${var.managed_ng_contexts[count.index].lt_config.custom_ami_id}"
  disable_api_termination = "${var.managed_ng_contexts[count.index].lt_config.disable_api_termination}"
  metadata_options {        
      http_endpoint               = try(var.managed_ng_contexts[count.index].lt_config.http_endpoint, "enabled")
      http_tokens                 = try(var.managed_ng_contexts[count.index].lt_config.http_tokens, "required") #tfsec:ignore:aws-autoscaling-enforce-http-token-imds
      http_put_response_hop_limit = try(var.managed_ng_contexts[count.index].lt_config.http_put_response_hop_limit, 2)      
  }
  tag_specifications {        
      resource_type = "${var.managed_ng_contexts[count.index].lt_config.tag_specifications.resource_type}"
      tags          = merge(var.managed_ng_contexts[count.index].lt_config.tag_specifications.tags, var.managed_ng_contexts[count.index].tags)    
  }
  lifecycle {
    create_before_destroy = false
  }
  user_data = base64encode(
    templatefile("${path.module}/templates/userdata-non-ami.tpl", local.userdata_params[count.index])
  )  
}

#######################
# Managed Node Group  #
#######################
resource "aws_eks_node_group" "mn_ng" {
  count = length(var.managed_ng_contexts) > 0 ? length(var.managed_ng_contexts) : 0
  #count = 0

  cluster_name = "${var.managed_ng_contexts[count.index].cluster_name}"
  version = "${var.managed_ng_contexts[count.index].force_update_version}"
  node_group_name_prefix = "${var.managed_ng_contexts[count.index].node_group_name_prefix}"
  #node_role_arn = "arn:aws:iam::682331604648:role/project/project-eks-node-group-ng_role"
  node_role_arn = "${var.managed_ng_contexts[count.index].node_role_arn}"
  subnet_ids = "${var.managed_ng_contexts[count.index].subnet_ids}"
  scaling_config {
    desired_size = "${var.managed_ng_contexts[count.index].desired_size}"
    max_size     = "${var.managed_ng_contexts[count.index].max_size}"
    min_size     = "${var.managed_ng_contexts[count.index].min_size}"    
  }
  update_config {
    #max_unavailable = "${var.managed_ng_contexts[count.index].max_unavailable}" # Only 1 available. Either max nodes or maxed percentage
    max_unavailable_percentage = "${var.managed_ng_contexts[count.index].max_unavailable_percentage}"    
  }
  capacity_type = "${var.managed_ng_contexts[count.index].capacity_type}"
  force_update_version = "${var.managed_ng_contexts[count.index].force_update_version}"
  labels = "${var.managed_ng_contexts[count.index].force_update_version}"

  tags = merge(var.managed_ng_contexts[count.index].lt_config.tag_specifications.tags, var.managed_ng_contexts[count.index].tags)
  # Optional: Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size,tags]
  }  
  
  # TODO - Dynamic taint section here
  #taint {}

  launch_template {
    name = aws_launch_template.lt_mn_ng[count.index].name
    version = aws_launch_template.lt_mn_ng[count.index].latest_version
  }


}  

### Commented out the below
/*
resource "aws_eks_cluster" "example" {  
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  name     = var.clusters[count.index].cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.clusters[count.index].eks_subnets
    ## Security Group ID for communication between worker node and control plan - optional
    #security_group_ids = var.clusters[count.index].eks_security_groups
        
    endpoint_private_access = var.clusters[count.index].endpoint_private_access
    ## Subnet must have tag: "kubernetes.io/role/internal-elb: 1" to enable load-balancer
  }

  enabled_cluster_log_types = var.clusters[count.index].enabled_cluster_log_types

  encryption_config{
    resources = ["secrets"]
    provider {
    key_arn = var.k8s_kms_key_arn 
    }
  }

  tags = var.asg_tags

  version = var.clusters[count.index].eks_version
  
  # # Need to do research more about outpost_config
  # outpost_config {
  #   control_plane_instance_type = var.clusters[count.index].control_plane_instance_type
  # }

  # Already address the below in iam role creation
  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  #depends_on = [ var.eks_cluster_depends_on ]
  #depends_on = [aws_cloudwatch_log_group.example]
}


data "tls_certificate" "cluster_ca_cert" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  url = aws_eks_cluster.example[count.index].identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "openid_connect_provider" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = data.tls_certificate.cluster_ca_cert[count.index].certificates[*].sha1_fingerprint
  url             = data.tls_certificate.cluster_ca_cert[count.index].url
}

data "aws_iam_policy_document" "openid_connect_assume_role_policy" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      #test     = "StringEquals"
      test     = "StringLike"
      variable = "${replace(aws_iam_openid_connect_provider.openid_connect_provider[count.index].url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }
    condition {
      #test     = "StringEquals"
      test     = "StringLike"
      variable = "${replace(aws_iam_openid_connect_provider.openid_connect_provider[count.index].url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      #test     = "StringEquals"
      test     = "StringLike"
      variable = "${replace(aws_iam_openid_connect_provider.openid_connect_provider[count.index].url, "https://", "")}:sub"
      values   = ["system:serviceaccount:amazon-cloudwatch:cloudwatch-agent"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.openid_connect_provider[count.index].arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "openid_connect_role" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  #count = 0  
  assume_role_policy = data.aws_iam_policy_document.openid_connect_assume_role_policy[count.index].json
  name               = "${format("%s%s",var.clusters[count.index].cluster_name,"-openid_connect_role")}"
  depends_on = [aws_eks_cluster.example]
  path = var.iam_role_path
  permissions_boundary = var.permissions_boundary
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "CloudWatch-AdministratorAccess" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  #count = 0
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.openid_connect_role[count.index].name
  depends_on = [aws_iam_role.openid_connect_role]
}

resource "aws_iam_role_policy_attachment" "CloudWatch-CloudWatchAgentServerPolicy" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  #count = 0
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.openid_connect_role[count.index].name
  depends_on = [aws_iam_role.openid_connect_role]
}
*/