output "lt_mn_ng_obj" {
  value = module.eks_mn_ng_creation.lt_mn_ng_obj
  description = "Launch template Object"
}

output "managed_ng_obj" {
  value = module.eks_mn_ng_creation.managed_ng_obj
  description = "Managed Node Groups Object"
}

# output "userdata_params" {
#   value = aws_launch_template.lt_mn_ng
#   description = "Launch template Object"
# }

# output "userdata_params" {
#   value = module.eks_mn_ng_creation.userdata_params
# }

# output "managed_ng_contexts" {
#   value = local.managed_ng_contexts
# }

# output "openid_connect_sa_role_objs" {
#   value = module.eks_cluster_creation.openid_connect_sa_role_objs
# }

# output "endpoint" {
#   value = module.eks_cluster_creation.endpoint
#   #value = concat(module.eks_cluster_creation.*.endpoint, [])#[0]
# }

# output "kubeconfig-certificate-authority-data" {
#   value = module.eks_cluster_creation.kubeconfig-certificate-authority-data

# }
# output "rancher2_bootstrap_admin_url" {    
#     value       = var.create_rancher_config ? module.rancher_admin_config.*.rancher2_bootstrap_admin_url : []
#     #value       = var.create_rancher_config ? module.rancher_admin_config.*.vpc_arn : data.aws_vpc.vpc_main.*.arn
#     description = "The rancher2_bootstrap_admin_url of the current Rancher"
# }

# output "rancher2_bootstrap_admin_token" {    
#     value       = var.create_rancher_config ? module.rancher_admin_config.*.rancher2_bootstrap_admin_token : []
#     sensitive = true
#     #value       = var.create_rancher_config ? module.rancher_admin_config.*.vpc_id : data.aws_vpc.vpc_main.*.id
#     description = "The rancher2_bootstrap_admin_token of the current Rancher"
# }

# output "rancher_eks_minimum_policy_arn" {
#     value = var.create_rancher_config ? module.iam_role_policy_creation.*.rancher_eks_minimum_policy_arn : []
#     description = "rancher_eks_minimum_policy_arn arn"
# }

# output "rancher_eks_service_role_policy_arn" {
#     value = var.create_rancher_config ? module.iam_role_policy_creation.*.rancher_eks_service_role_policy_arn : []
#     description = "rancher_eks_minimum_policy_arn arn"
# }

# output "rancher_eks_vpc_role_policy_arn" {
#     value = var.create_rancher_config ? module.iam_role_policy_creation.*.rancher_eks_vpc_role_policy_arn : []
#     description = "rancher_eks_minimum_policy_arn arn"
# }

# output "rancher_eks_role_arn" {
#     value = var.create_rancher_config ? module.iam_role_policy_creation.*.rancher_eks_role_arn : []
#     description = "rancher_eks_minimum_policy_arn arn"
# }

# ## EKS Cluster
# output "aws_launch_template_names" {
#   description = "rancher_eks eks_launch_template arn"
#   value       = var.create_rancher_config ? module.eks_cluster_creation.*.aws_launch_template_names : []
# }

# output "rancher2_cloud_credential_ids" {
#   description = "rancher2_cloud_credential_id"
#   value       = var.create_rancher_config ? module.eks_cluster_creation.*.rancher2_cloud_credential_ids : []
# }

# output "rancher_eks_cluster_ids" {
#   description = "rancher_eks_vpc_role_policy_arn arn"
#   value       = var.create_rancher_config ? module.eks_cluster_creation.*.rancher_eks_cluster_ids : []
# }

# output "rancher_eks_cluster_eks_config_v2" {
#   description = "rancher_eks_cluster_eks_config_v2"
#   value       = var.create_rancher_config ? module.eks_cluster_creation.*.rancher_eks_cluster_eks_config_v2 : []
# }