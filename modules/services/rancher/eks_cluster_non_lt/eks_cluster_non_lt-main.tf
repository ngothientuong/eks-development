terraform {
  required_version = ">= 1.3.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.37.0"
    }

    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }

    rancher2 = {
      source  = "rancher/rancher2"
      #version = "1.24.1"
      version = "1.25.0"
    }
    
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
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

# provider config for admin
provider "rancher2" {
  api_url   = var.rancher_admin_url
  token_key = var.rancher_admin_token
  insecure  = true
}

# Lookup user_data
data "template_file" "amzn2-eks-generic" {
  template = file("../../../../files/amzn2-eks-generic.sh")
  vars = {
    ec2_remote_ssh_public_key = var.ec2_remote_ssh_public_key
    # project_archive             = var.project_archive
    # aws_region                  = var.aws_region
    # aws_access_key              = var.aws_access_key
    # aws_secret_key              = var.aws_secret_key
    # docker_registry_url         = var.docker_registry_url
    # dockerhub_registry_url      = var.dockerhub_registry_url
    # dockerhub_registry_username = data.aws_ssm_parameter.dockerhub_registry_username.value
    # dockerhub_registry_password = data.aws_ssm_parameter.dockerhub_registry_password.value
    # logstash_url                = var.logstash_url
  }
}

# Create random for the usage of the Launch template
resource "random_id" "id" {
  # count = var.create_rancher_config && length(var.eks_non_lt_node_group) > 0 ? 1 : 0
  # byte_length = 8
  count = var.create_rancher_config && length(var.clusters) > 0 ? length(var.clusters) : 0
  keepers = {
    cluster_count = length(var.clusters)
  }
  #keepers = {
    #launch_template = each.value.launch_template.block_device_mappings[0].device_name
    # cluster_name              = each.value.cluster_name
    # description               = each.value.description
    # vpc_id                    = each.value.vpc_id
    # #cloud_credential_id       = ""
    # #region                    = ""
    # k8s_kms_key_id = each.value.k8s_kms_key_id
    # secrets_encryption        = each.value.secrets_encryption
    # eks_security_groups          = each.value.eks_security_groups
    # service_role             = each.value.service_role
    # eks_subnets              = each.value.eks_subnets
    # #tags                     = ""      
    # enable_cluster_monitoring = each.value.enable_cluster_monitoring
    # eks_version               = each.value.eks_version
    # logging_types             = each.value.logging_types
    # private_access            = each.value.private_access
    # public_access             = each.value.public_access
    # node_groups = each.value.node_groups
  #}
  byte_length = 8
}

# Create a launch template for the EKS node groups
resource "aws_launch_template" "eks_launch_template" {

  count = var.create_rancher_config && length(random_id.id) > 0 ? length(random_id.id) : 0
  name = "${var.clusters[count.index].cluster_name}-${random_id.id[count.index].hex}"
  
  dynamic "block_device_mappings" {
    for_each = var.clusters[count.index].launch_template.block_device_mappings
    content {
      device_name = block_device_mappings.value.device_name
      dynamic "ebs" {
        for_each = var.clusters[count.index].launch_template.block_device_mappings
        content {
          delete_on_termination = ebs.value.ebs.delete_on_termination
          volume_size = ebs.value.ebs.volume_size
          volume_type = ebs.value.ebs.volume_type
        }        
      }
    }
  }
  #block_device_mappings = var.clusters[count.index].launch_template.block_device_mappings
  default_version = "${var.clusters[count.index].launch_template.default_version}"
  disable_api_stop = "${var.clusters[count.index].launch_template.disable_api_stop}"
  disable_api_termination = "${var.clusters[count.index].launch_template.disable_api_termination}"
  ebs_optimized = "${var.clusters[count.index].launch_template.ebs_optimized}"
  depends_on = [
    random_id.id
  ]
}

# Create EKS role for Rancher to operate with  
resource "rancher2_cloud_credential" "rancher_aws_cloud_credential" {
  count = var.create_rancher_config ? 1 : 0
  name = var.rancher2_aws_credential  
  description = "Create a new rancher2 Cloud Credential"

  amazonec2_credential_config {
    access_key = var.rancher_eks_user_access_key
    secret_key = var.rancher_eks_user_secret_key
    default_region     = var.aws_region
  }
}

## Create eks cluster with service role permission 
## while using aws user credential for rancher to authenticate/utilize other cloud resources with aws
resource "rancher2_cluster" "eks_cluster_non_lt" {
  #count = var.create_rancher_config ? 1 : 0
  count = var.create_rancher_config && length(var.clusters) > 0 ? length(var.clusters) : 0

  name = var.clusters[count.index].cluster_name
  description = var.clusters[count.index].description
  enable_cluster_monitoring = var.clusters[count.index].enable_cluster_monitoring

  eks_config_v2 {
    name = var.clusters[count.index].cluster_name  # Give this name the same as cluster name or else cluster name won't change in an update
    cloud_credential_id = rancher2_cloud_credential.rancher_aws_cloud_credential[0].id
    region = var.aws_region
    kms_key = var.clusters[count.index].k8s_kms_key_id 
    secrets_encryption = var.clusters[count.index].secrets_encryption
    security_groups = var.clusters[count.index].eks_security_groups
    subnets = var.clusters[count.index].eks_subnets        
    kubernetes_version = var.clusters[count.index].eks_version #"1.24"
    logging_types = var.clusters[count.index].logging_types    #["audit", "api"]    
    tags = var.asg_tags
    service_role = var.clusters[count.index].service_role
    private_access = var.clusters[count.index].private_access
    public_access = var.clusters[count.index].public_access
    
    dynamic "node_groups" {
      for_each = var.clusters[count.index].node_groups
        content {
          name = node_groups.value.name
          instance_type = node_groups.value.instance_type
          desired_size = node_groups.value.desired_size
          max_size = node_groups.value.max_size
          disk_size = node_groups.value.disk_size
          subnets = var.asg_subnet       
          launch_template {
            id = aws_launch_template.eks_launch_template[count.index].id
            version = aws_launch_template.eks_launch_template[count.index].latest_version            
          }
          tags = var.asg_tags
          user_data = <<EOF
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="//"

--//
Content-Transfer-Encoding: 7bit
Content-Type: text/x-shellscript
Mime-Version: 1.0

#!/bin/bash -xe

yum update -y

# epel repo
if rpm -q epel-release | grep "not installed" > /dev/null
then
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
fi

# dependencies
yum install -y vim wget grep jq bind-utils htop iscsi-initiator-utils


########################################################################################
# session manager
########################################################################################
if rpm -q epel-release | grep "not installed" > /dev/null
then
yum install -y https://s3.us-east-2.amazonaws.com/amazon-ssm-us-east-2/latest/linux_amd64/amazon-ssm-agent.rpm
fi
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent


# install kubectl
curl -OL "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"  
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && rm -rf kubectl;


########################################################################################
# node exporter
########################################################################################
groupadd -f --gid 611 node_exporter
id -u node_exporter &>/dev/null || useradd --comment "node exporter account" --uid 611 --gid 611 -s /sbin/nologin --system node_exporter

wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar -xvzf node_exporter-1.3.1.linux-amd64.tar.gz
mkdir -p /usr/local/bin
cp -rfp node_exporter-1.3.1.linux-amd64/node_exporter /usr/local/bin/node_exporter
chmod 755 /usr/local/bin/node_exporter
rm -rf node_exporter-1.3.1.linux-amd64.tar.gz
rm -rf node_exporter-1.3.1.linux-amd64

aws s3 cp s3://bl-artifacts/node_exporter/etc/systemd/system/node_exporter.service /etc/systemd/system/node_exporter.service

# added with iptables at top of script
# firewall-cmd --add-port 6101/tcp --permanent
# firewall-cmd --reload

systemctl daemon-reload
systemctl enable node_exporter --now
systemctl restart node_exporter

# Add private key for remote ssh purpose
mkdir -p /home/ec2-user/.ssh
# Public key of the ec2-user that is used to create the machine initially
# Hard coded tngo
cat > /home/ec2-user/.ssh/authorized_keys <<-EOT
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8jnUrRWJt/Rvvu0m4Haj0OPu9uGpT8ELSGYIXliCTbt0YJ+P6l/aDmghzx+ppl5PHjq8M448xFo6T3Jf8n5Aqu+rDnAEs86cfHESJ977oRUqzD9h4xNRe1ZUFdmqxPKhe43KSKKsu3KldpcUkQTNZO24rphryIwtGkT2UaNxFKKT+fV9/brmZjR5206cQBkospqK7CzNhm1ziSdgHCubwS14AhzSGNyk32RM4UfQBMFHOONaZR1XXXWz7tYScew5JA8sv33my5+3hYaz2w9ZWGcoWH/cTIz/h/9ptdna5BGdz7IbLvpXEvseVa+isVoXjWYwtxgvTZ8ulswZ6e7kR tngo-keypair
EOT
chown -R 'ec2-user:ec2-user' /home/ec2-user/.ssh
chmod 0700 /home/ec2-user/.ssh
chmod -R 0600 /home/ec2-user/.ssh/*
--//         
          EOF
        }
      }    

  }
  lifecycle {
    #ignore_changes = all
    #ignore_changes = [ eks_config_v2.node_groups.launch_template ]
    create_before_destroy = true
  }
  depends_on = [var.rancher2_cluster_depends_on]
}
