import numpy as np
from jinja2 import Environment, FileSystemLoader


with open(r"./cluster_names.txt", 'r') as fp:
    cluster_length = len(fp.readlines())
    fp.close()

cluster_index_list = np.arange(0,cluster_length,1)
#print('cluster_index_list is', cluster_index_list)

template_folder = "./tf_local_files/"
template_name = "generic.j2"
environment = Environment(loader=FileSystemLoader(template_folder))
template = environment.get_template(template_name)

for student in cluster_index_list:
    filename = template_name.replace('.j2','.tf')
    content = template.render(
        cluster_index_list=cluster_index_list
    )
    with open(template_folder + '/' + filename, mode="w", encoding="utf-8") as message:
        message.write(content)
        print(f"... wrote {filename}")