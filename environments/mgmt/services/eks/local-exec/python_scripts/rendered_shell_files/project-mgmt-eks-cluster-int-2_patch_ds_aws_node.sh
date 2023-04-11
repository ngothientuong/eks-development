#!/bin/bash
aws eks update-kubeconfig --region us-east-2 --name project-mgmt-eks-cluster-int-2 --kubeconfig ~/.kube/project-mgmt-eks-cluster-int-2.config
kubectl --kubeconfig ~/.kube/project-mgmt-eks-cluster-int-2.config -n kube-system patch daemonset aws-node --type='strategic' -p='{"spec":{"template":{"spec":{"nodeSelector":{"io.cilium/aws-node-enabled":"true"}}}}}'