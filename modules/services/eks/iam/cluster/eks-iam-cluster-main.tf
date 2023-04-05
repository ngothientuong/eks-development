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

# Assume Role for EKS
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    sid = "EKSClusterAssumeRole"
    actions = ["sts:AssumeRole"]
  }

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = ["arn:aws:iam::682331604648:user/tuong.ngo@bylight.com"]
      type        = "AWS"
    }
  }

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = ["arn:aws:iam::682331604648:root"]
      type        = "AWS"
    }
  }
}

resource "aws_iam_role" "example" {
  name               = "project-eks-cluster-example"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  path               = "/project/"
  permissions_boundary = var.permissions_boundary
  force_detach_policies = true
}


resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.example.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.example.name
}

resource "aws_iam_role_policy_attachment" "AdministratorAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.example.name
}

resource "aws_iam_role" "ng_role" {
  name = "project-eks-node-group-ng_role"
  path               = "/project/"
  permissions_boundary = var.permissions_boundary
  force_detach_policies = true

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Sid = "EKSWorkerAssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  
}

resource "aws_iam_instance_profile" "ng_role" {
  name = "${aws_iam_role.ng_role.name}-IP"
  role = aws_iam_role.ng_role.name
  
  path = "/project/"  
  # lifecycle {
  #   create_before_destroy = false
  # }
}

resource "aws_iam_role_policy_attachment" "ng_role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.ng_role.name
}

resource "aws_iam_role_policy_attachment" "ng_role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.ng_role.name
}

resource "aws_iam_role_policy_attachment" "ng_role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.ng_role.name
}

resource "aws_iam_role_policy_attachment" "ng_role-AdministratorAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.ng_role.name
}

resource "aws_iam_role_policy_attachment" "ng_role-AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ng_role.name
}

resource "aws_iam_role_policy_attachment" "ng_role-AmazonS3FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.ng_role.name
}
resource "aws_iam_role_policy_attachment" "ng_role-AmazonEC2FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.ng_role.name
}

# ## Kube2iam
# resource "aws_iam_policy" "kube2iam_policy" {
#   name        = "project-kube2iam-AR-policy"
#   path        = "/project/"
#   description = "Allow kube2iam AR"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid = "", 
#         Effect = "Allow",
#         Action = "sts:AssumeRole",
#         Resource = "arn:aws:iam::682331604648:role/project/project-*"
#       },
#     ]
#   })
# }
# resource "aws_iam_role" "kube2iam" {  
#   name = "project-eks-kube2iam_role"
#   path               = "/project/"
#   permissions_boundary = var.permissions_boundary
#   force_detach_policies = true

#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           "AWS" = aws_iam_role.ng_role.arn
#         }       
#     }]
#     Version = "2012-10-17"
#   })  
#   depends_on = [aws_iam_role.ng_role,aws_iam_policy.kube2iam_policy]
# }
# resource "aws_iam_role_policy_attachment" "kube2iam-role-policy-attachment" {
#   policy_arn = aws_iam_policy.kube2iam_policy.arn
#   role       = aws_iam_role.kube2iam.name
# }