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
# providers
########################################################

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

## Add additional tags for subnets for k8s auto discovery
resource "aws_security_group" "eks_sg_default" {  
  count = length(var.clusters_vpc) > 0 ? length(var.clusters_vpc) : 0
  #count = 0
  name        = "${format("%s%s%s%s%s","eks-",var.clusters_info[count.index].cluster_env,"-",var.clusters_info[count.index].cluster_name,"-sg-default")}"
  vpc_id      = var.clusters_vpc[count.index].id 
  # SSH
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
    security_groups = [replace(var.clusters_obj[count.index].vpc_config[0].cluster_security_group_id,"\"","")]
  }
  # HTTP Port
  ingress {
    description = "HTTP port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [replace(var.clusters_obj[count.index].vpc_config[0].cluster_security_group_id,"\"","")]
  }
  # HTTP Secured port 443
  ingress {
    description = "Secured port"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [replace(var.clusters_obj[count.index].vpc_config[0].cluster_security_group_id,"\"","")]
  }
  # HTTP Port
  ingress {
    description = "Allow Ping"
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [replace(var.clusters_obj[count.index].vpc_config[0].cluster_security_group_id,"\"","")]
  }
  
  ## App ports
    # HTTP Port
  ingress {
    description = "Allow Ping"
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [replace(var.clusters_obj[count.index].vpc_config[0].cluster_security_group_id,"\"","")]
  }
  # EKS Default
  ingress {
    description = "EKS access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks      = ["0.0.0.0/0"]  #  "10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16" are default from EKS control plane     
    self = true
    security_groups = [replace(var.clusters_obj[count.index].vpc_config[0].cluster_security_group_id,"\"","")]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]  #  "10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16" are default from EKS control plane    
  }
  tags = {
    Name = "${format("%s%s%s%s%s","eks-",var.clusters_info[count.index].cluster_env,"-",var.clusters_info[count.index].cluster_name,"-sg-default")}"
    "${format("%s%s%s%s","kubernetes.io/cluster/",var.clusters_info[count.index].cluster_env,"-",var.clusters_info[count.index].cluster_name)}" = "owned"
    #"aws:eks:cluster-name" = "${format("%s%s%s%s","kubernetes.io/cluster/",var.clusters_info[count.index].cluster_env,"-",var.clusters_info[count.index].cluster_name)}"
  }
  
}

# ## Add SSH, HTTP and HTTPS rule to control plane SG 
# ## which will propagate to the ASG
# resource "aws_security_group_rule" "control_plan_SG_SSH" {
#   count = length(var.clusters_info) > 0 ? length(var.clusters_info) : 0
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = var.clusters_obj[count.index].vpc_config[0].cluster_security_group_id
#   #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]  
# }
# resource "aws_security_group_rule" "control_plan_SG_HTTP" {
#   count = length(var.clusters_info) > 0 ? length(var.clusters_info) : 0
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = var.clusters_obj[count.index].vpc_config[0].cluster_security_group_id
#   #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]  
# }
# resource "aws_security_group_rule" "control_plan_SG_HTTP" {
#   count = length(var.clusters_info) > 0 ? length(var.clusters_info) : 0
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = var.clusters_obj[count.index].vpc_config[0].cluster_security_group_id
#   #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]  
# }
# ## Allow ping
# resource "aws_security_group_rule" "control_plan_SG_HTTP" {
#   count = length(var.clusters_info) > 0 ? length(var.clusters_info) : 0
#   type              = "ingress"
#   from_port         = "8"
#   to_port           = "0"
#   protocol          = "icmp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = var.clusters_obj[count.index].vpc_config[0].cluster_security_group_id
#   #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]  
# }

# resource "aws_ec2_tag" "eks_cluster_shared" {  
#   count = length(var.aws_subnets_ids) > 0 ? length(var.aws_subnets_ids) : 1
#   resource_id = var.aws_subnets_ids[count.index].subnet_id
#   key         = "${format("%s%s","kubernetes.io/cluster/",var.aws_subnets_ids[count.index].cluster_name)}"
#   value       = "shared"  
# }