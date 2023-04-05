#output cluster_role_arn {
#  value = aws_iam_role.example.arn
#  description = "Shared role arn of all EKS clusters"
#}
#output ng_role_arn {
#  value = aws_iam_role.ng_role.arn
#  description = "Shared node group role arn of all EKS clusters"
#}

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