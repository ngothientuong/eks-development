#!/bin/bash
aws eks update-kubeconfig --region us-east-2 --name project-mgmt-eks-cluster-int-2 --kubeconfig ~/.kube/project-mgmt-eks-cluster-int-2.config
kubectl --kubeconfig ~/.kube/project-mgmt-eks-cluster-int-2.config -n kube-system apply -f ./project-mgmt-eks-cluster-int-2-hubble-ui-alb.yaml