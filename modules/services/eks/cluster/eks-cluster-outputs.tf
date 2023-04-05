output "clusters_objs" {
  value = concat(aws_eks_cluster.example, [])
  description = "Object of clusters"
}

output "openid_connect_sa_role_objs" {
  value = concat (aws_iam_role.openid_connect_role, [])
}

output "endpoint" {
  value = concat(aws_eks_cluster.example.*.endpoint, [])#[0]
}

output "kubeconfig-certificate-authority-data" {
  value = concat(aws_eks_cluster.example.*.certificate_authority, [])#[0].data#[0]
}
# output "rancher_eks_minimum_policy_arn" {
#   description = "rancher_eks_minimum_policy_arn arn"
#   value       = concat(aws_iam_policy.rancher_eks_minimum_policy.*.arn, [])[0]
# }

# output "rancher_eks_service_role_policy_arn" {
#   description = "rancher_eks_service_role_policy_arn arn"
#   value       = concat(aws_iam_policy.rancher_eks_service_role_policy.*.arn, [])[0]
# }

# output "rancher_eks_vpc_role_policy_arn" {
#   description = "rancher_eks_vpc_role_policy_arn arn"
#   value       = concat(aws_iam_policy.rancher_eks_vpc_role_policy.*.arn, [])[0]
# }

# output "rancher_eks_role_arn" {
#   description = "rancher_eks_role_arn arn"
#   value       = concat(aws_iam_role.rancher_eks_role.*.arn, [])[0]
# }