# tngo.tfvars
// Initialization of S3 and dynamododb_table
dynamodb_table_name = "tim-tf-k8s-state"
s3_bucket_name = "tim-tf-k8s-state"

aws_region = "eu-west-2"

name = "tngo-mgmt-eu"
vpc_cidr = "110.0.0.0/16"
azs             = ["eu-west-1a", "eu-west-1b"]
private_subnets = ["110.0.1.0/24", "110.0.3.0/24"]
private_subnets = ["110.0.0.0/24", "110.0.2.0/24"]
enable_nat_gateway = true
single_nat_gateway = true
one_nat_gateway_per_az = false

enable_vpn_gateway = true

