#!/bin/bash
aws eks update-kubeconfig --region us-east-2 --name project-mgmt-eks-cluster-int-test --kubeconfig ~/.kube/project-mgmt-eks-cluster-int-test.config
kubectl --kubeconfig ~/.kube/project-mgmt-eks-cluster-int-test.config -n kube-system apply -f ./project-mgmt-eks-cluster-int-test-hubble-ui-alb.yaml