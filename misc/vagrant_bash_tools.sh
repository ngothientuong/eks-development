#!/bin/bash
aws eks update-kubeconfig --region us-east-2 --name project-mgmt-eks-cluster-int-2
aws eks update-kubeconfig --region us-east-2 --name project-mgmt-eks-cluster-int-test
aws eks update-kubeconfig --region us-east-2 --name project-mgmt-eks-cluster-rancher-test
aws eks update-kubeconfig --region eu-west-2 --name project-eumgmt-eks-eu-west-2

# Python Package
pip install numpy

# Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh