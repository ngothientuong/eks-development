#!/bin/bash
aws eks update-kubeconfig --region us-east-2 --name project-mgmt-eks-cluster-rancher-test --kubeconfig ~/.kube/project-mgmt-eks-cluster-rancher-test.config
kubectl --kubeconfig ~/.kube/project-mgmt-eks-cluster-rancher-test.config -n kube-system patch daemonset aws-node --type='strategic' -p='{"spec":{"template":{"spec":{"nodeSelector":{"io.cilium/aws-node-enabled":"true"}}}}}'