data "aws_availability_zones" "available" {}

# locals {
#   azs      = slice(data.aws_availability_zones.available.names, 0, 2)
#   vpc_cidr = "105.0.0.0/16"
#   vpc_cdir_elements = split(".",local.vpc_cidr)  
#   private_subnets = [for myidx in range(length(local.azs)) : join(",",[local.vpc_cdir_elements[0],local.vpc_cdir_elements[1], tostring(tonumber(local.vpc_cdir_elements[2]) + myidx * 2 )  ,replace(local.vpc_cdir_elements[3],"/16","/24" )  ]) ]
#   public_subnets = [for myidx in range(length(local.azs)) : join(",",[local.vpc_cdir_elements[0],local.vpc_cdir_elements[1], tostring(tonumber(local.vpc_cdir_elements[2]) + myidx * 2 + 1 )  ,replace(local.vpc_cdir_elements[3],"/16","/24" )  ]) ]
# }

# locals {
#   vpc_cdir_elements = "${split(".",local.vpc_cidr)}"
# }

# locals {
#   public_subnet = join(",",[local.vpc_cdir_elements[0],local.vpc_cdir_elements[1] + var.count.index])
# }

# resource "aws_subnet" "public" {
#   count = "${length(local.azs)}"
#   vpc_id =	"vpc-03fdd10513a75bc26"
#   cidr_block = local.public_subnet
# }  

output "azs_names" {  
  value       =  "${length(local.azs)}"
}

output "vpc_cdir_elements" {  
  value       =  "${local.vpc_cdir_elements}"
}
output "public_subnet" {  
  value       =  "${local.public_subnet}"
}
# resource "aws_subnet" "public" {
#   count = 1
#   azs             = local.azs
#   vpc_cidr = module.vpc
#   public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]

  
#   tags= {
#     Group = var.env
#     Name = "${format("%s%s%s",var.project_id,"-",var.env)}"
#     Project = var.project_name
#     VPC = "${format("%s%s%s",var.project_id,"-",var.env)}"
#    }  
#  }