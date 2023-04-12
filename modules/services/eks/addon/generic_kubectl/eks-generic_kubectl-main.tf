locals {
  # userdata_params = flatten([
  # for each_cluster in var.clusters_info: [{  
  #   cluster_name =  each_cluster.cluster_name    
  #   aws_caller_identity = var.aws_caller_identity        
  #   service_account_role_arn = format("%q",element([ for sa_role in var.service_account_role_arns : sa_role.arn if length(regexall(each_cluster.cluster_name, sa_role.arn)) > 0 ],0))    
  #   vpc_cidr_block = each_cluster.cidr_block   
  #   kubectl_command = each_cluster.kubectl_command 
  #   lb_address = ""
  # }]])  
  userdata_params = [{
    cluster_name =  var.clusters_info.cluster_name  
    aws_region = var.aws_region
    aws_caller_identity = var.aws_caller_identity        
    service_account_role_arn = format("%q",element([ for sa_role in var.service_account_role_arns : sa_role.arn if length(regexall(var.clusters_info.cluster_name, sa_role.arn)) > 0 ],0))    
    vpc_cidr_block = var.clusters_info.cidr_block   
    pre_template_kubectl_command = var.clusters_info.pre_template_kubectl_command 
    post_template_kubectl_command = var.clusters_info.post_template_kubectl_command 
    #####################
    ## Generic run use  #
    #####################
    #lb_address = ""
  }]  
  template_files = flatten([
    for each_yaml_file in fileset("${path.module}/manifests/${var.sub_path}/", "*tpl.yaml"): [{ 
      name = each_yaml_file        
      full_path_file = "${format("%s%s%s",path.module,"/manifests/${var.sub_path}/",each_yaml_file)}"
      rendered_full_path_file = "${format("%s%s%s",path.module,"/manifests/${var.sub_path}/rendered/",replace(each_yaml_file,".yaml.tpl",""))}"
  }]])

  # Product of cluster's userdata_params list and template_file lists
  # Format of the product list is: [[userdata_params[0],template_files[0]],..,[userdata_params[n],template_files[n]]]
  clusters_x_templates = setproduct(local.userdata_params,local.template_files)
}

## Create local rendered template files
## Note: clusters_x_templates[*][0] represents userdata_params
##       clusters_x_templates[*][1] represents template_files
resource "local_file" "rendered_templates" {
  count = length(local.clusters_x_templates) > 0 ? length(local.clusters_x_templates) : 0
  content = templatefile(local.clusters_x_templates[count.index][1].full_path_file,local.clusters_x_templates[count.index][0])
  filename = "${format("%s%s%s",local.clusters_x_templates[count.index][1].rendered_full_path_file,"-",local.clusters_x_templates[count.index][0].cluster_name)}"
  depends_on = [ null_resource.set_initial_state, var.root_depends_on ]
}

## Let this run first thing for template to get a chance to generate
## Before rendering
resource "null_resource" "set_initial_state" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "echo \"0\" > ~/counter"
  }
  depends_on = [ var.root_depends_on ]
}


## Apply corresponding rendered template files to each cluster
## Note: clusters_x_templates[*][0] represents userdata_params
##       clusters_x_templates[*][1] represents template_files
resource "null_resource" "pre_template_kubectl" {  
  triggers = {
    always_run = "${timestamp()}"
  }
  ## Syntax: python <pyscript> <clustername> <endpoint> <cluster_ca_certificate> <env> <count.index> <total run>
  provisioner "local-exec" {    
    command = <<-EOT
      # Prevent other root module to run at the same time
      while [[ $(cat ~/module_count) != $(echo ${var.module_count}) ]]
      do
        echo "Waiting on root module job index ${tonumber(var.module_count) - 1}"             
        sleep 2
      done   
        # Remove Cluster contexts in kubectl      
        if [ "$(kubectl config get-contexts | grep  ${local.clusters_x_templates[0][0].cluster_name}  )" != '' ]  
        then         
          kubectl config delete-cluster arn:aws:eks:${var.aws_region}:${var.aws_caller_identity}:cluster/${local.clusters_x_templates[0][0].cluster_name}
          kubectl config unset users.arn:aws:eks:${var.aws_region}:${var.aws_caller_identity}:cluster/${local.clusters_x_templates[0][0].cluster_name} 
          kubectl config delete-context arn:aws:eks:${var.aws_region}:${var.aws_caller_identity}:cluster/${local.clusters_x_templates[0][0].cluster_name} 
        fi      
        # Replace null character with empty list
        if [ -f ~/.kube/config ]
        then
          sed -i 's/null/\[\]/g' ~/.kube/config
          if [ "$(tail -n 2 ~/.kube/config | grep 'command')" != "" ]
          then
            rm -rf ~/.kube/config
          fi
        fi      
        # Readd cluster context in kubectl                        
        if [ "$(kubectl config get-contexts | grep  ${local.clusters_x_templates[0][0].cluster_name}  )" == '' ] ; then aws eks update-kubeconfig --region ${var.aws_region} --name ${local.clusters_x_templates[0][0].cluster_name} ; fi              
        # Run pre_template kubectl_command from root module
        ${local.userdata_params[0].pre_template_kubectl_command}
        sleep 5

      echo "Pre-Template kubectl run of job ${var.module_count} completed"        
    EOT    
    }
  depends_on = [ null_resource.set_initial_state, local_file.rendered_templates ]
}

## Apply corresponding rendered template files to each cluster
## Note: clusters_x_templates[*][0] represents userdata_params
##       clusters_x_templates[*][1] represents template_files
resource "null_resource" "template_apply" {
  count = length(local.clusters_x_templates) > 0 ? length(local.clusters_x_templates) : 0
  triggers = {
    always_run = "${timestamp()}"
  }
  ## Syntax: python <pyscript> <clustername> <endpoint> <cluster_ca_certificate> <env> <count.index> <total run>
  provisioner "local-exec" {    
    command = <<-EOT
      # Give a few second for 1 loop to finish before the next            
      while [[ ($(cat ~/counter) != $(echo ${count.index})) && ($(cat ~/module_count) != $(echo ${var.module_count})) ]]
      do
        echo "Waiting on Job index ${count.index - 1}"             
        sleep 2
      done   
              
        ## Run kubectl for multiple yaml.tpl files     
        kubectl apply -f ${local_file.rendered_templates[count.index].filename} --force --grace-period 0                 
        sleep 5              


      echo "Template apply of root module ${var.module_count} - Job ${count.index} completed"  
      ## Allow the next loop to go
      echo ${count.index + 1} > ~/counter      
    EOT    
    }
  depends_on = [ local_file.rendered_templates, null_resource.set_initial_state, null_resource.pre_template_kubectl ]
}

## Run post template kubectl Job
resource "null_resource" "post_template_kubectl" {  
  triggers = {
    always_run = "${timestamp()}"
  }
  ## Syntax: python <pyscript> <clustername> <endpoint> <cluster_ca_certificate> <env> <count.index> <total run>
  provisioner "local-exec" {    
    command = <<-EOT
      # Prevent other root module to run at the same time
      while [[ $(cat ~/module_count) != $(echo ${var.module_count}) ]]
      do
        echo "Waiting on root module job index ${tonumber(var.module_count) - 1}"             
        sleep 2
      done   
        # Run post_template kubectl_command from root module
        ${local.userdata_params[0].post_template_kubectl_command}
        sleep 5

      echo "Post-Template kubectl run of job ${var.module_count} completed" 
      ## Allow the next loop to go
      echo ${tonumber(var.module_count) + 1} > ~/module_count        
    EOT    
    }
  depends_on = [ local_file.rendered_templates, null_resource.set_initial_state, null_resource.template_apply ]
}