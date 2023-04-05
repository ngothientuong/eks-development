#!/bin/bash
terraform plan -var-file=/home/vagrant/bl/bl-ops-eks-poc-terraform/mhv-ms/users_spec/tngo/mgmt_user.tfvars -out tfm.out
terraform apply tfm.out
