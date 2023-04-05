output "aws_launch_template_names" {
  description = "rancher_eks eks_launch_template arn"
  value       = concat(aws_launch_template.eks_launch_template.*.name, [])[0]
}

output "rancher2_cloud_credential_ids" {
  description = "rancher2_cloud_credential_id"
  value       = concat(rancher2_cloud_credential.rancher_aws_cloud_credential.*.id, [])[0]
}

output "rancher_eks_cluster_ids" {
  description = "rancher_eks_vpc_role_policy_arn arn"
  value       = concat(rancher2_cluster.eks_cluster_non_lt.*.id, [])[0]
}

output "rancher_eks_cluster_eks_config_v2" {
  description = "rancher_eks_cluster_eks_config_v2"
  value       = concat(rancher2_cluster.eks_cluster_non_lt.*.eks_config_v2, [])[0]
}