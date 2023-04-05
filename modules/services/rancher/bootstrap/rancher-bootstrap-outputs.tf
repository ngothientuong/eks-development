output "rancher2_bootstrap_admin_url" {
  description = "rancher2_bootstrap_admin_url"
  value       = concat(rancher2_bootstrap.admin.*.url, [])[0]
}

output "rancher2_bootstrap_admin_token" {
  description = "rancher2_bootstrap_admin_token"
  value       = concat(rancher2_bootstrap.admin.*.token, [])[0]
}