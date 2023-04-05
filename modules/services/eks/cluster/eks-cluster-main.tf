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
      values = ["system:serviceaccount:*:*"]
      #values   =  [ "system:serviceaccount:kube-system:aws-node",
      #              "system:serviceaccount:kube-system:efs-csi-sa",
      #              "system:serviceaccount:kube-system:fsx-csi-sa",
      #              "system:serviceaccount:aws-for-fluent-bit:aws-for-fluent-bit-sa",
      #              "system:serviceaccount:kube-system:aws-load-balancer-controller-sa",
      #              "system:serviceaccount:kube-system:aws-node-termination-handler-sa",
      #              "system:serviceaccount:aws-privateca-issuer:aws-privateca-issuer-sa",
      #              "system:serviceaccount:cert-manager:cert-manager",
      #              "system:serviceaccount:external-secrets:external-secrets-sa",
      #              "system:serviceaccount:karpenter:karpenter",
      #              "system:serviceaccount:keda:keda-operator-sa",
      #              "system:serviceaccount:amazon-cloudwatch:cloudwatch-agent",
      #              "system:serviceaccount:kube-system:cluster-autoscaler",
      #              "system:serviceaccount:*:*"
      #            ]
    }
    condition {
      #test     = "StringEquals"
      test     = "StringLike"
      variable = "${replace(aws_iam_openid_connect_provider.openid_connect_provider[count.index].url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
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

### IAM Roles for IRSA
# VPC CNI
resource "aws_iam_role_policy_attachment" "vpi_cni_irsa" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  #count = 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.openid_connect_role[count.index].name
  depends_on = [aws_iam_role.openid_connect_role]
}

# EBS CSI - Must add external snapshotter before EBS CSI
# External-Snapshotter: https://github.com/kubernetes-csi/external-snapshotter
resource "aws_iam_role_policy_attachment" "ebs_csi_irsa" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  #count = 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.openid_connect_role[count.index].name
  depends_on = [aws_iam_role.openid_connect_role]
}

## Cluster-Autoscaler
resource "aws_iam_policy" "cluster_autoscaler" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  name        = "${format("%s%s",var.clusters[count.index].cluster_name,"cluster-autoscaler")}"
  path               = "/project/"
  #permissions_boundary = var.permissions_boundary  
  description = "cluster-autoscaler-policy"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/k8s.io/cluster-autoscaler/${var.clusters[count.index].cluster_name}": "owned"
                }
            }
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeAutoScalingGroups",
                "ec2:DescribeLaunchTemplateVersions",
                "autoscaling:DescribeTags",
                "autoscaling:DescribeLaunchConfigurations",
                "ec2:DescribeInstanceTypes"
            ],
            "Resource": "*"
        }
    ]
}  
  EOF
}
resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  #count = 0
  policy_arn = aws_iam_policy.cluster_autoscaler[count.index].arn
  role       = aws_iam_role.openid_connect_role[count.index].name
  depends_on = [aws_iam_role.openid_connect_role]
}

## AWS ACM 
resource "aws_iam_policy" "aws_acm" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  name        = "${format("%s%s",var.clusters[count.index].cluster_name,"aws_acm")}"
  path               = "/project/"
  #permissions_boundary = var.permissions_boundary  
  description = "aws-acm-policy"
  policy      = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
     {
       "Sid": "awspcaissuer",
       "Action": [
         "acm-pca:DescribeCertificateAuthority",
         "acm-pca:GetCertificate",
         "acm-pca:IssueCertificate"
       ],
       "Effect": "Allow",
       "Resource": "arn:aws:acm-pca:us-east-2:682331604648:certificate-authority/*"
     }
   ]
 }
  EOF
}
resource "aws_iam_role_policy_attachment" "aws_acm" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  #count = 0
  policy_arn = aws_iam_policy.aws_acm[count.index].arn
  role       = aws_iam_role.openid_connect_role[count.index].name
  depends_on = [aws_iam_role.openid_connect_role]
}

## AWS LB Controller
## Public 
## AWS ACM 
data "template_file" "iam-aws-lb-controller-public-cloud" {
  template = file("${path.module}/svc-iam-policy/aws_lb_controller_iam_policy_public_cloud.json")
}
resource "aws_iam_policy" "AWSLoadBalancerControllerIAMPolicyPublic" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  name        = "${format("%s%s",var.clusters[count.index].cluster_name,"AWSLoadBalancerControllerIAMPolicyPublic")}"
  path               = "/project/"
  #permissions_boundary = var.permissions_boundary  
  description = "aws-lb-controller-policy-public-cloud"
  policy      = "${data.template_file.iam-aws-lb-controller-public-cloud.rendered}"
}
resource "aws_iam_role_policy_attachment" "AWSLoadBalancerControllerIAMPolicyPublic" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  #count = 0
  policy_arn = aws_iam_policy.AWSLoadBalancerControllerIAMPolicyPublic[count.index].arn
  role       = aws_iam_role.openid_connect_role[count.index].name
  depends_on = [aws_iam_role.openid_connect_role]
}
# ## AWS Gov Cloud
# data "template_file" "iam-aws-lb-controller-gov-cloud" {
#   template = file("${path.module}/svc-iam-policy/aws_lb_controller_iam_policy_gov_cloud.json")
# }
# resource "aws_iam_policy" "AWSLoadBalancerControllerIAMPolicyGov" {
#   count = length(var.clusters) > 0 ? length(var.clusters) : 0
#   name        = "${format("%s%s",var.clusters[count.index].cluster_name,"AWSLoadBalancerControllerIAMPolicyGov")}"
#   path               = "/project/"
#   #permissions_boundary = var.permissions_boundary  
#   description = "aws-lb-controller-policy-gov-cloud"
#   policy      = "${data.template_file.iam-aws-lb-controller-gov-cloud.rendered}"
# }
# resource "aws_iam_role_policy_attachment" "AWSLoadBalancerControllerIAMPolicyGov" {
#   count = length(var.clusters) > 0 ? length(var.clusters) : 0
#   #count = 0
#   policy_arn = aws_iam_policy.AWSLoadBalancerControllerIAMPolicyGov[count.index].arn
#   role       = aws_iam_role.openid_connect_role[count.index].name
#   depends_on = [aws_iam_role.openid_connect_role]
# }



## User assumed role
data "aws_iam_policy_document" "users_sts_role_policy" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = ["arn:aws:iam::682331604648:user/bl-service-account-1","arn:aws:iam::682331604648:user/tuong.ngo@bylight.com"]
      type        = "AWS"
    }
  }
}
resource "aws_iam_role" "iam_console_sts_role" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  #count = 0  
  assume_role_policy = data.aws_iam_policy_document.users_sts_role_policy[count.index].json
  name               = "${format("%s%s",var.clusters[count.index].iam_console_user_role,"-sts_role")}"
  depends_on = [aws_eks_cluster.example]
  path = var.iam_role_path
  permissions_boundary = var.permissions_boundary
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "sts-AdministratorAccess" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  #count = 0
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.iam_console_sts_role[count.index].name
  depends_on = [aws_iam_role.iam_console_sts_role]
}

## Kube2iam
resource "aws_iam_policy" "kube2iam_policy" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  name        = "${format("%s%s",var.clusters[count.index].kube2iam_role,"-k2iam_role")}"
  path        = "/project/"
  description = "Allow kube2iam AR"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "", 
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Resource = "arn:aws:iam::682331604648:role/project/project-*"
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "kube2iam-role-policy-attachment" {
  count = length(var.clusters) > 0 ? length(var.clusters) : 0
  policy_arn = aws_iam_policy.kube2iam_policy[count.index].arn
  role       = aws_iam_role.openid_connect_role[count.index].name
}