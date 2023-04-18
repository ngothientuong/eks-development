import numpy as np
import os, sys, re

## Get current namespace
full_cluster_list = os.system("kubectl config get-contexts  > full.txt")
fullo = open("full.txt")
my_cluster = []
for line in fullo.readlines():
  if not re.search("NAME", line):
    my_cluster = my_cluster + [line.replace('\n','')]
#print(my_cluster)  
for idx,cluster in enumerate(my_cluster):
  columns = cluster.split()  
  if columns[0] == '*':    
    print()
    if re.search("arn",columns[-1]):  
      current_ns = "default"
      print("Current namespace: default")
    else:
      current_ns = columns[-1]
      print('Current namespace: ', columns[-1])
    current_cluster = columns[1]
fullo.close()
os.remove("full.txt")

## Get namespace and input
full_namespace_list = os.system("kubectl get namespace  > namespace.txt")
fullo = open("namespace.txt")
my_namespace = []
for line in fullo.readlines():
  if not re.search("NAME", line):
    my_namespace = my_namespace + [line.replace('\n','')]
#print(my_namespace)  
for idx,ns in enumerate(my_namespace):
  columns = ns.split()  
  if columns[0] == current_ns:
    print('[',idx,']  *  ', columns[0])
  else:
    print('[',idx,']     ', columns[0])
print("Select number for NAMESPACE or press 'Enter' if no change: " )
ns_choice = input()
print()
print()
for idx,ns in enumerate(my_namespace):
  columns = ns.split()
  # If switch to different namespace
  if ns_choice and (int(ns_choice) == idx) and columns[0] != current_ns:
    use_context = "kubectl config set-context --current --namespace=" + columns[0]
    os.system(use_context)      
    print("Current cluster : ", current_cluster ,"   [NO CHANGE]")
    print("Namespace changed to: ", columns[0])
  # Else if stay in the same namespace
  elif ((not ns_choice) or (int(ns_choice) == idx)) and columns[0] == current_ns:    
    print("Current cluster : ", current_cluster ,"   [NO CHANGE]")
    print("Current namespace: ", current_ns,"   [NO CHANGE]")
os.remove("namespace.txt")
    

