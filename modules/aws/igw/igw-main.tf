data "aws_vpc" "vpc_main" {    
  tags = {
    Group = var.env
    Name = "${format("%s%s%s",var.project_id,"-",var.env)}"
    Project = var.project_name
    VPC = "${format("%s%s%s",var.project_id,"-",var.env)}"
  }
}

resource "aws_internet_gateway" "igw" {  
  vpc_id = data.aws_vpc.vpc_main.id
    
  tags = {
    Group = var.env
    Name = "${format("%s%s%s%s",var.project_id,"-",var.env,"-igw")}"
    Project = var.project_name
    VPC = "${format("%s%s%s",var.project_id,"-",var.env)}"
  }
}