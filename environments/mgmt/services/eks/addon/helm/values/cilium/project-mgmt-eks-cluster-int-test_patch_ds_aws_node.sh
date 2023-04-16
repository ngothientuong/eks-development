#!/bin/bash
aws eks update-kubeconfig --region us-east-2 --name project-mgmt-eks-cluster-int-test --kubeconfig ~/.kube/project-mgmt-eks-cluster-int-test.config
kubectl --kubeconfig ~/.kube/project-mgmt-eks-cluster-int-test.config -n kube-system patch daemonset aws-node --type='strategic' -p='{"spec":{"template":{"spec":{"nodeSelector":{"io.cilium/aws-node-enabled":"true"}}}}}'

## ipSec key
if [ "$(kubectl --kubeconfig ~/.kube/project-mgmt-eks-cluster-int-test.config get secret cilium-ipsec-keys -n kube-system)" == "" ]
then
  kubectl --kubeconfig ~/.kube/project-mgmt-eks-cluster-int-test.config create -n kube-system secret generic cilium-ipsec-keys --from-literal=keys="3 rfc4106(gcm(aes)) $(echo $(dd if=/dev/urandom count=20 bs=1 2> /dev/null | xxd -p -c 64)) 128"
fi