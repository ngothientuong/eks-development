Instruction to run this add on
    Important: Has to run twice

First install:
1.  Copy files from local_exec/python_scripts/rendered_shell_files 
    and put under helm/values/cilium
2.  Remove the ca.cert and ca.key value in helm's value file for each cluster if exists
3.  Run terraform init, plan and apply as usual

Second Install:
4.  After Cilium was installed the first time, view the cilium-ca secret to obtain certificate, key
5.  Insert the ca.cert and ca.key into helm's value files for each cluster
6.  Rerun terraform plan, terraform apply to update the ca certs across cluster
7.  Check if cilium-ca and hubble-ca-secret have the same keys and values across ALL cluster as it's needed for cluster communication

## Do not enable the following components as it'll break cilium controller
- gatewayAPI
- monitor
- pre-flight


