#################
# Data sources  #
#################
## VPC
data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

## Rancher datasources


data "aws_vpc" "vpc_main" {    
  tags = {
    ## MHV 
    #Environment = var.env
    #ProjectName = var.project_name 
        ## By Light
    Group = var.env
    Name  = "${format("%s%s%s",var.project_id,"-",var.env)}"
  }

}

data "aws_subnets" "private" {
    filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc_main.id]
  }
  
  tags = {
    #Name = "${format("%s%s%s","MHV:",var.env,"*App:Private")}"
    Name = "${format("%s%s%s%s",var.project_id,"-",var.env,"-private-subnet-*")}"
  }
}

locals {
    tags = {
        Group = "${var.env}"
        Name = "${format("%s%s%s",var.project_id,"-",var.env)}"
        Project = "${var.project_name}"
        VPC = "${format("%s%s%s",var.project_id,"-",var.env)}"
    }     
    # VPC
    vpc_id = data.aws_vpc.vpc_main.id        
}


resource "aws_acmpca_certificate_authority_certificate" "subordinate" {
  certificate_authority_arn = aws_acmpca_certificate_authority.subordinate.arn

  certificate       = aws_acmpca_certificate.subordinate.certificate
  certificate_chain = aws_acmpca_certificate.subordinate.certificate_chain
}

resource "aws_acmpca_certificate" "subordinate" {
  certificate_authority_arn   = aws_acmpca_certificate_authority.root.arn
  certificate_signing_request = aws_acmpca_certificate_authority.subordinate.certificate_signing_request
  signing_algorithm           = "SHA512WITHRSA"

  template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/SubordinateCACertificate_PathLen0/V1"

  validity {
    type  = "YEARS"
    value = 1
  }
}

resource "aws_acmpca_certificate_authority" "subordinate" {
  type = "SUBORDINATE"

  certificate_authority_configuration {
    key_algorithm     = "RSA_2048"
    signing_algorithm = "SHA512WITHRSA"

    subject {
      common_name = "Eks subordinate CA MHV By Light"
      country = "US"
      state = "Texas"
      locality = "Dallas"      
      organization = "By Light"
      organizational_unit = "MHV Team"
    }
  }
}

resource "aws_acmpca_certificate_authority" "root" {
  type = "ROOT"

  certificate_authority_configuration {
    key_algorithm     = "RSA_4096"
    signing_algorithm = "SHA512WITHRSA"

    subject {
      common_name = "Eks Root CA MHV By Light"
      country = "US"
      state = "Texas"
      locality = "Dallas"      
      organization = "By Light"
      organizational_unit = "MHV Team"
    }
  }
}

resource "aws_acmpca_certificate_authority_certificate" "root" {
certificate_authority_arn = aws_acmpca_certificate_authority.root.arn

  certificate       = aws_acmpca_certificate.root.certificate
  #certificate_chain = aws_acmpca_certificate.root.certificate_chain
}

resource "aws_acmpca_certificate" "root" {
  certificate_authority_arn   = aws_acmpca_certificate_authority.root.arn
  certificate_signing_request = aws_acmpca_certificate_authority.root.certificate_signing_request
  signing_algorithm           = "SHA512WITHRSA"

  #template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/SubordinateCACertificate_PathLen0/V1"

  validity {
    type  = "YEARS"
    value = 1
  }
}

data "aws_partition" "current" {}

# resource "aws_s3_bucket" "acmpca-s3" {
#   bucket = "acmpca-s3"
# }

# data "aws_iam_policy_document" "acmpca_bucket_access" {
#   statement {
#     actions = [
#       "s3:GetBucketAcl",
#       "s3:GetBucketLocation",
#       "s3:PutObject",
#       "s3:PutObjectAcl",
#     ]

#     resources = [
#       aws_s3_bucket.acmpca-s3.arn,
#       "${aws_s3_bucket.acmpca-s3.arn}/*",
#     ]

#     principals {
#       identifiers = ["acm-pca.amazonaws.com"]
#       type        = "Service"
#     }
#   }
# }

# resource "aws_s3_bucket_policy" "acmpca-s3" {
#   bucket = aws_s3_bucket.acmpca-s3.id
#   policy = data.aws_iam_policy_document.acmpca_bucket_access.json
# }

# resource "aws_acmpca_certificate_authority" "example" {
#   certificate_authority_configuration {
#     key_algorithm     = "RSA_4096"
#     signing_algorithm = "SHA512WITHRSA"

#     subject {
#       common_name = "eks.mhv.bylightsdc.bylight.com"
#       country = "US"
#       state = "Texas"
#       locality = "Dallas"      
#       organization = "By Light"
#       organizational_unit = "MHV Team"
#     }
#   }

#   revocation_configuration {
#     crl_configuration {
#       custom_cname       = "*.eks.mhv.bylightsdc.bylight.com"
#       enabled            = true
#       expiration_in_days = 365
#       s3_bucket_name     = aws_s3_bucket.acmpca-s3.id
#     }
#   }

#   depends_on = [aws_s3_bucket_policy.acmpca-s3]
# }
