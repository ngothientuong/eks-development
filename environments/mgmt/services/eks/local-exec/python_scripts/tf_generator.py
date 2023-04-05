### Creator: Tuong Ngo
### Note: The resource files has to be in format eks-<subpath>-<subpath>...-<subpath>.j2
###       The version files has to be in format eks-<subpath>-<subpath>...-<subpath>-versions.j2

### Important: The required_providers for a provider, i.e. kubernetes has to have 
#                   configuration_aliases = [ kubernetes.<alias name> ]
#              that matches with the provider, i.e. kubernetes alias attribute 
#                   alias = <alias name>                    

import os, sys
from jinja2 import Template

# n = len(sys.argv)
# for arg in sys.argv:
#     print("Argument is: \n ", arg)
print("Cluster Name: ",sys.argv[1])

jinja2_template_dir = os.getcwd() + "/jinja2_templates/"
services_dir = os.getcwd() + '/../../'
# Note: File name structure is eks-<subpath>-<subpath>...-<subpath>.j2
template_files = ["eks-configmap.j2","eks-addon-cert_manager.j2","eks-addon-cert_manager-aws_pca_issuer.j2","eks-addon-aws_lb_controller.j2","eks-addon-kubectl_run.j2","eks-addon-ext_snapshotter.j2",
                  "eks-addon-ext_secret.j2","eks-addon-kube2iam.j2","eks-addon-velero.j2","eks-addon-calico.j2"
                  ]

###################################
## RESOURCE AND PROVIDER SECTION  #
###################################
# Generate multiple individual main tf files for each resources
for j2_tpl in template_files:
    print("Working on template file: ", j2_tpl)
    # Define source templates and destinations
    source_template = jinja2_template_dir + j2_tpl
    dest_file = services_dir + j2_tpl.replace('-','/').replace('.j2','/') + sys.argv[4] + '-' + j2_tpl.replace('.j2','') + "-main-" + sys.argv[5] + '.tf'
    fo = open(source_template, "r+")
    template = Template(fo.read())
    rendered_content = template.render(cluster_name = sys.argv[1], endpoint = sys.argv[2], cluster_ca_certificate = sys.argv[3], count_index = sys.argv[5]) #,env = sys.argv[4], count_index = sys.argv[5])                            
    #print(rendered_content);
    fo.close()
    # Write rendered content into a new file
    dfo = open(dest_file,"w+")    
    dfo.write(rendered_content)
    dfo.close()

###################################
## REQUIRED PROVIDER SECTION      #
###################################
# Contruct a list for the jinja2 for loops to generate multiple required providers    
cluster_list_file = os.getcwd() + "/python_scripts/cluster_names.txt"
provider_list = []
file1 = open(cluster_list_file,"r+")
count = 0
 
for line in file1.readlines():
    # Get next line from file
    provider_list = provider_list + [line.strip()]
 
file1.close()

print(provider_list)
# Generate the versions tf file.
# End result will just be 1 single versions.tf file
for j2_tpl in template_files:
    source_version_template = jinja2_template_dir + j2_tpl.replace('.j2','-versions.j2')
    dest_version_file = services_dir + j2_tpl.replace('-','/').replace('.j2','/') + sys.argv[4] + '-' + j2_tpl.replace('.j2','-versions.tf')
    fo = open(source_version_template, "r+")
    template = Template(fo.read())
    rendered_content = template.render( provider_list = provider_list) #,env = sys.argv[4], count_index = sys.argv[5])
    fo.close()
    # Write rendered content into a new file
    dfo = open(dest_version_file,"w+")    
    dfo.write(rendered_content)
    dfo.close()
