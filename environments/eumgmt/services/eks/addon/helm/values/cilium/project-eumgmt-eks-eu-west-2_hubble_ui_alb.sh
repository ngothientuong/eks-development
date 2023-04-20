#!/bin/bash
aws eks update-kubeconfig --region eu-west-2 --name project-eumgmt-eks-eu-west-2 --kubeconfig ~/.kube/project-eumgmt-eks-eu-west-2.config
kubectl --kubeconfig ~/.kube/project-eumgmt-eks-eu-west-2.config -n kube-system apply -f ./project-eumgmt-eks-eu-west-2-hubble-ui-alb.yaml