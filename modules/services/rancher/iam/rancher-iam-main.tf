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

# Create EKS role for Rancher to operate with
resource "aws_iam_role" "rancher_eks_role" {
  count = var.create_rancher_config ? 1 : 0

  name = var.eks_service_role_name
  force_detach_policies = true

  assume_role_policy = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
    }
  )
}

## Minimum EKS Permissions
resource "aws_iam_policy" "rancher_eks_minimum_policy" {
  count = var.create_rancher_config ? 1 : 0

  name = var.iam_minimum_policy_name
  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "EC2Permisssions",
              "Effect": "Allow",
              "Action": [
                  "ec2:RunInstances",
                  "ec2:RevokeSecurityGroupIngress",
                  "ec2:RevokeSecurityGroupEgress",
                  "ec2:DescribeRegions",
                  "ec2:DescribeVpcs",
                  "ec2:DescribeTags",
                  "ec2:DescribeSubnets",
                  "ec2:DescribeSecurityGroups",
                  "ec2:DescribeRouteTables",
                  "ec2:DescribeLaunchTemplateVersions",
                  "ec2:DescribeLaunchTemplates",
                  "ec2:DescribeKeyPairs",
                  "ec2:DescribeInternetGateways",
                  "ec2:DescribeImages",
                  "ec2:DescribeAvailabilityZones",
                  "ec2:DescribeAccountAttributes",
                  "ec2:DeleteTags",
                  "ec2:DeleteSecurityGroup",
                  "ec2:DeleteKeyPair",
                  "ec2:CreateTags",
                  "ec2:CreateSecurityGroup",
                  "ec2:CreateLaunchTemplateVersion",
                  "ec2:CreateLaunchTemplate",
                  "ec2:CreateKeyPair",
                  "ec2:AuthorizeSecurityGroupIngress",
                  "ec2:AuthorizeSecurityGroupEgress"
              ],
              "Resource": "*"
          },
          {
              "Sid": "CloudFormationPermisssions",
              "Effect": "Allow",
              "Action": [
                  "cloudformation:ListStacks",
                  "cloudformation:ListStackResources",
                  "cloudformation:DescribeStacks",
                  "cloudformation:DescribeStackResources",
                  "cloudformation:DescribeStackResource",
                  "cloudformation:DeleteStack",
                  "cloudformation:CreateStackSet",
                  "cloudformation:CreateStack"
              ],
              "Resource": "*"
          },
          {
              "Sid": "IAMPermissions",
              "Effect": "Allow",
              "Action": [
                  "iam:PassRole",
                  "iam:ListRoles",
                  "iam:ListRoleTags",
                  "iam:ListInstanceProfilesForRole",
                  "iam:ListInstanceProfiles",
                  "iam:ListAttachedRolePolicies",
                  "iam:GetRole",
                  "iam:GetInstanceProfile",
                  "iam:DetachRolePolicy",
                  "iam:DeleteRole",
                  "iam:CreateRole",
                  "iam:AttachRolePolicy"
              ],
              "Resource": "*"
          },
          {
              "Sid": "KMSPermisssions",
              "Effect": "Allow",
              "Action": "kms:ListKeys",
              "Resource": "*"
          },
          {
              "Sid": "EKSPermisssions",
              "Effect": "Allow",
              "Action": [
                  "eks:UpdateNodegroupVersion",
                  "eks:UpdateNodegroupConfig",
                  "eks:UpdateClusterVersion",
                  "eks:UpdateClusterConfig",
                  "eks:UntagResource",
                  "eks:TagResource",
                  "eks:ListUpdates",
                  "eks:ListTagsForResource",
                  "eks:ListNodegroups",
                  "eks:ListFargateProfiles",
                  "eks:ListClusters",
                  "eks:DescribeUpdate",
                  "eks:DescribeNodegroup",
                  "eks:DescribeFargateProfile",
                  "eks:DescribeCluster",
                  "eks:DeleteNodegroup",
                  "eks:DeleteFargateProfile",
                  "eks:DeleteCluster",
                  "eks:CreateNodegroup",
                  "eks:CreateFargateProfile",
                  "eks:CreateCluster"
              ],
              "Resource": "*"
          }
      ]
    }
  )

}
## Service Role Permissions
## Permissions required for Rancher to create service role on users behalf during the EKS cluster creation process.
resource "aws_iam_policy" "rancher_eks_service_role_policy" {
  count = var.create_rancher_config ? 1 : 0
  
  name = var.service_role_policy  
  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "IAMPermisssions",
          "Effect": "Allow",
          "Action": [
            "iam:AddRoleToInstanceProfile",
            "iam:AttachRolePolicy",
            "iam:CreateInstanceProfile",
            "iam:CreateRole",
            "iam:CreateServiceLinkedRole",
            "iam:DeleteInstanceProfile",
            "iam:DeleteRole",
            "iam:DetachRolePolicy",
            "iam:GetInstanceProfile",
            "iam:GetRole",
            "iam:ListAttachedRolePolicies",
            "iam:ListInstanceProfiles",
            "iam:ListInstanceProfilesForRole",
            "iam:ListRoles",
            "iam:ListRoleTags",
            "iam:PassRole",
            "iam:RemoveRoleFromInstanceProfile"
          ],
          "Resource": "*"
        }
      ]
    }    
  )
}

## VPC Permissions
## Permissions required for Rancher to create VPC and associated resources
resource "aws_iam_policy" "rancher_eks_vpc_role_policy" {
  count = var.create_rancher_config ? 1 : 0
  
  name = var.vpc_role_policy  
  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "VPCPermissions",
          "Effect": "Allow",
          "Action": [
            "ec2:ReplaceRoute",
            "ec2:ModifyVpcAttribute",
            "ec2:ModifySubnetAttribute",
            "ec2:DisassociateRouteTable",
            "ec2:DetachInternetGateway",
            "ec2:DescribeVpcs",
            "ec2:DeleteVpc",
            "ec2:DeleteTags",
            "ec2:DeleteSubnet",
            "ec2:DeleteRouteTable",
            "ec2:DeleteRoute",
            "ec2:DeleteInternetGateway",
            "ec2:CreateVpc",
            "ec2:CreateSubnet",
            "ec2:CreateSecurityGroup",
            "ec2:CreateRouteTable",
            "ec2:CreateRoute",
            "ec2:CreateInternetGateway",
            "ec2:AttachInternetGateway",
            "ec2:AssociateRouteTable"
          ],
          "Resource": "*"
        }
      ]
    }
  )
}

# Attach policies to the role
resource "aws_iam_role_policy_attachment" "rancher_eks_minimum_policy_to_role" {
  #count = 
  role = aws_iam_role.rancher_eks_role[0].name
  policy_arn = aws_iam_policy.rancher_eks_minimum_policy[0].arn  
  depends_on = [
    aws_iam_role.rancher_eks_role
  ]

}
resource "aws_iam_role_policy_attachment" "rancher_eks_service_role_policy_to_role" {
  #count = 
  role = aws_iam_role.rancher_eks_role[0].name
  policy_arn = aws_iam_policy.rancher_eks_service_role_policy[0].arn
  depends_on = [
    aws_iam_role.rancher_eks_role
  ]

}
resource "aws_iam_role_policy_attachment" "rancher_eks_vpc_role_policy_to_role" {
  #count = 
  role = aws_iam_role.rancher_eks_role[0].name
  policy_arn = aws_iam_policy.rancher_eks_vpc_role_policy[0].arn
  depends_on = [
    aws_iam_role.rancher_eks_role
  ]

}

# Add additional required policy
resource "aws_iam_role_policy_attachment" "rancher_eks_additional_Amazon_policy_to_role" {
  count = length(var.additional_iam_policies) > 0 ? length(var.additional_iam_policies) : 0
  role = aws_iam_role.rancher_eks_role[0].name
  policy_arn = var.additional_iam_policies[count.index]
  depends_on = [
    aws_iam_role.rancher_eks_role
  ]
}

# Add aws_auth config role for kubectl
data "aws_iam_policy_document" "kubectl_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::682331604648:root"]
    }
  }
}

resource "aws_iam_role" "eks_kubectl_role" {
  name               = "example-kubectl-access-role"
  assume_role_policy = "${data.aws_iam_policy_document.kubectl_assume_role_policy.json}"
}
resource "aws_iam_role_policy_attachment" "eks_kubectl-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.eks_kubectl_role.name}"
}
resource "aws_iam_role_policy_attachment" "eks_kubectl-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.eks_kubectl_role.name}"
}
resource "aws_iam_role_policy_attachment" "eks_kubectl-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.eks_kubectl_role.name}"
}