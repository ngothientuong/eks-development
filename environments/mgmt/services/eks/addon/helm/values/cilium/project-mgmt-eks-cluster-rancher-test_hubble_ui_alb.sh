#!/bin/bash
aws eks update-kubeconfig --region us-east-2 --name project-mgmt-eks-cluster-rancher-test --kubeconfig ~/.kube/project-mgmt-eks-cluster-rancher-test.config
kubectl --kubeconfig ~/.kube/project-mgmt-eks-cluster-rancher-test.config -n kube-system apply -f ./project-mgmt-eks-cluster-rancher-test-hubble-ui-alb.yaml