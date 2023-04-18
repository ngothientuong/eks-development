import numpy as np
import os, sys, re

full_cluster_list = os.system("kubectl config get-contexts  > full.txt")
fullo = open("full.txt")
my_cluster = []
for line in fullo.readlines():
  if not re.search("NAME", line):
    my_cluster = my_cluster + [line.replace('\n','')]
#print(my_cluster)  
for idx,cluster in enumerate(my_cluster):
  columns = cluster.split()
  #print("cluster index: ", idx, " is: " ,columns)
  if columns[0] == '*':
    print('[',idx,']  *  ', columns[1])
  else:
    print('[',idx,']     ', columns[0])
print("Select number for cluster or press 'Enter' if no change: " )
cluster_choice = input()
print()
print()
for idx,cluster in enumerate(my_cluster):
  columns = cluster.split()
  # If switch to different context then print cluster and current namespace
  if cluster_choice and (int(cluster_choice) == idx) and columns[0] != '*':
    use_context = "kubectl config use-context " + columns[0]
    os.system(use_context)  
    print("Cluster: ", columns[0])
    if re.search("arn",columns[-1]):        
        print("Namespace: default")
    else:
        print("Namespace: ", columns[-1] )
  # Else if stay in current context then print current cluster and current namespace
  #elif not cluster_choice or (int(cluster_choice) == idx) and columns[0] == '*':
  elif ((not cluster_choice) or (int(cluster_choice) == idx)) and columns[0] == '*':    
    print("Cluster: ", columns[1], "    [NO CHANGE]")
    if re.search("arn",columns[-1]):        
        print("Namespace: default")
    else:
        print("Namespace: ", columns[-1] )
os.remove("full.txt")
    

