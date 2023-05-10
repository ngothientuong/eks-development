#!/bin/bash
aws eks update-kubeconfig --region us-east-2 --name project-mgmt-eks-cluster-int-2
aws eks update-kubeconfig --region us-east-2 --name project-mgmt-eks-cluster-int-test
aws eks update-kubeconfig --region us-east-2 --name project-mgmt-eks-cluster-rancher-test
aws eks update-kubeconfig --region eu-west-2 --name project-eumgmt-eks-eu-west-2

pip install numpy

