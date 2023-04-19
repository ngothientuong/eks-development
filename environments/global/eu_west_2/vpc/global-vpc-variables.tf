variable "aws_region" {
  type    = string
  #default = "us-east-2"
}
variable "aws_access_key" {
  type = string
  //default = "TF_VAR_aws_access_key"  
}
variable "aws_secret_key" {
  type = string
  //default = "TF_VAR_aws_secret_key"
}
variable "dynamodb_table_name" {
  type = string
  //default = "TF_VAR_aws_secret_key"
}

variable "s3_bucket_name" {
  type = string
  //default = "TF_VAR_aws_secret_key"
}

variable "vpc" {
  type = any
  default = {}
  //default = "TF_VAR_aws_secret_key"
}

variable "tgw" {
  type = any
  default = {}
  //default = "TF_VAR_aws_secret_key"
}