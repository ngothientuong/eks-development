#!/bin/bash

cd ./../../local-exec/
./plan_apply.sh
cd -
if [ -f "./replace_var.py" ]
then
    python ./replace_var.py
fi
#terraform init -backend-config=${tngo_spec}/user.hcl
terraform plan -var-file=/home/vagrant/bl/bl-ops-eks-poc-terraform/mhv-ms/users_spec/tngo/mgmt_user.tfvars -out tfm.out
terraform apply tfm.out
