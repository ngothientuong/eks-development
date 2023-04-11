########################################################
# providers
########################################################
terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
  }
}

resource "helm_release" "helm_release" {
  count = length(var.helm_info) > 0 ? length(var.helm_info) : 0
  name       = length(var.helm_info[count.index].name) > 0 ? var.helm_info[count.index].name :null
  repository = length(var.helm_info[count.index].repository) > 0 ? var.helm_info[count.index].repository : null
  chart      = length(var.helm_info[count.index].chart) > 0 ? var.helm_info[count.index].chart : null  
  version    = length(var.helm_info[count.index].version) > 0 ? var.helm_info[count.index].version : null  
  namespace  = length(var.helm_info[count.index].namespace) > 0 ? var.helm_info[count.index].namespace : "default"  
  create_namespace = try(var.helm_info[count.index].create_namespace,false)# User try() fnc for true/false
  values = length(var.helm_info[count.index].values) > 0 ? var.helm_info[count.index].values : []
  force_update = try(var.helm_info[count.index].force_update, false)
  recreate_pods = try(var.helm_info[count.index].recreate_pods,false)
  timeout = try(var.helm_info[count.index].timeout,300)
  verify = try(var.helm_info[count.index].verify,false)
  dynamic "set" {
    for_each = { for v in var.helm_info[count.index].set: v.name => v }
    content {
      name = set.value.name
      value = set.value.value
    }
  }  
  # prender doesn't work!
  depends_on = [var.helm_module_depends_on]
}



