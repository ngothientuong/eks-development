import numpy as np
import os
from jinja2 import Environment, FileSystemLoader

aws_region = 'us-east-2'

with open(r"./cluster_names.txt", 'r') as txt_file:
    cluster_length = len(txt_file.readlines())    
    txt_file.close()

   # Open the file in read mode - Python 3
file = open("cluster_names.txt")
# Create an empty list to store the cluster_names
cluster_names = []

# Iterate over the lines of the file
for line in file:
    # Remove the newline character at the end of the line
    line = line.strip()

    # Append the line to the list
    cluster_names.append(line)

# Print the list of lines
print(cluster_names) 

cluster_index_list = np.arange(0,cluster_length,1)
#print('cluster_index_list is', cluster_index_list)

# TF Files
template_folder = "./tf_local_files/"
for j2_file in os.listdir(template_folder):    
    template_name = j2_file
    environment = Environment(loader=FileSystemLoader(template_folder))
    template = environment.get_template(template_name)

    for student in cluster_index_list:
        filename = template_name.replace('.j2','.tf')
        content = template.render(
            cluster_index_list=cluster_index_list
        )
        with open(template_folder + '/' + filename, mode="w", encoding="utf-8") as message:
            message.write(content)
            #print(f"... wrote {filename}")

for cluster_name in cluster_names:    
    template_folder = "./sh_local_files/"
    #print('cluster_name: ', cluster_name)
    for j2_file in os.listdir(template_folder):  
        #print("shell j2 files: ", j2_file)  
        template_name = j2_file
        environment = Environment(loader=FileSystemLoader(template_folder))
        template = environment.get_template(template_name)        
        filename = cluster_name + '_' + template_name.replace('.j2','') 
        content = template.render(            
            cluster_name = cluster_name,
            aws_region = aws_region
        )
        with open('./rendered_shell_files/' + filename, mode="w", encoding="utf-8") as message:
            message.write(content)
            os.chmod('./rendered_shell_files/' + filename, 0o0777 )
            #print(f"... wrote {filename}")            
            message.close()