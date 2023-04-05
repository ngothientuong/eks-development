locals {
  userdata_params = flatten([
  for each_cluster in var.clusters: [{  
    cluster_name =  each_cluster.cluster_name    
    aws_caller_identity = var.aws_caller_identity
    image_version = var.image_version 
    service_account_role_arn = format("%q",element([ for sa_role in var.service_account_role_arns : sa_role.arn if length(regexall(each_cluster.cluster_name, sa_role.arn)) > 0 ],0))
  }]])  
  template_files = flatten([
    for each_yaml_file in fileset("${path.module}/manifests/", "*yaml.tpl"): [{ 
      name = each_yaml_file        
      full_path_file = "${format("%s%s%s",path.module,"/manifests/",each_yaml_file)}"
      rendered_full_path_file = "${format("%s%s%s",path.module,"/manifests/rendered/",replace(each_yaml_file,".yaml.tpl",""))}"
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
}

resource "null_resource" "set_initial_state" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "echo \"0\" > ~/counter"
  }
}

## Apply corresponding rendered template files to each cluster
## Note: clusters_x_templates[*][0] represents userdata_params
##       clusters_x_templates[*][1] represents template_files
resource "null_resource" "cluster_autoscaler_upgrade" {
  count = length(local.clusters_x_templates) > 0 ? length(local.clusters_x_templates) : 0
  triggers = {
    always_run = "${timestamp()}"
  }
  ## Syntax: python <pyscript> <clustername> <endpoint> <cluster_ca_certificate> <env> <count.index> <total run>
  provisioner "local-exec" {    
    command = <<-EOT
      # Give a few second for 1 loop to finish before the next            
      while [[ $(cat ~/counter) != $(echo ${count.index}) ]]
      do
        echo "Waiting on Job index ${count.index - 1}"             
        sleep 2
      done   


        # Remove Cluster contexts in kubectl      
        if [ "$(kubectl config get-contexts | grep  ${local.clusters_x_templates[count.index][0].cluster_name}  )" != '' ]  
        then         
          kubectl config delete-cluster arn:aws:eks:${var.aws_region}:${var.aws_caller_identity}:cluster/${local.clusters_x_templates[count.index][0].cluster_name}
          kubectl config unset users.arn:aws:eks:${var.aws_region}:${var.aws_caller_identity}:cluster/${local.clusters_x_templates[count.index][0].cluster_name} 
          kubectl config delete-context arn:aws:eks:${var.aws_region}:${var.aws_caller_identity}:cluster/${local.clusters_x_templates[count.index][0].cluster_name} 
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
        if [ "$(kubectl config get-contexts | grep  ${local.clusters_x_templates[count.index][0].cluster_name}  )" == '' ] ; then aws eks update-kubeconfig --region ${var.aws_region} --name ${local.clusters_x_templates[count.index][0].cluster_name} ; fi      
        ## Run kubectl for multiple yaml.tpl files     
        kubectl replace -f ${local_file.rendered_templates[count.index].filename} --force --grace-period 0 
        sleep 10
        kubectl -n kube-system logs deployment.apps/cluster-autoscaler           


      echo "Job ${count.index} completed"  
      ## Allow the next loop to go
      echo ${count.index + 1} > ~/counter      
    EOT    
    }
  depends_on = [ local_file.rendered_templates, null_resource.set_initial_state ]
}
