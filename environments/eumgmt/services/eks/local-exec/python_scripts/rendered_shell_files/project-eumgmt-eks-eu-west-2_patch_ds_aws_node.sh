#!/bin/bash
aws eks update-kubeconfig --region eu-west-2 --name project-eumgmt-eks-eu-west-2 --kubeconfig ~/.kube/project-eumgmt-eks-eu-west-2.config
kubectl --kubeconfig ~/.kube/project-eumgmt-eks-eu-west-2.config -n kube-system patch daemonset aws-node --type='strategic' -p='{"spec":{"template":{"spec":{"nodeSelector":{"io.cilium/aws-node-enabled":"true"}}}}}'
# Create secret for ipSec
if [ "$(kubectl --kubeconfig ~/.kube/project-eumgmt-eks-eu-west-2.config get secret cilium-ipsec-keys -n kube-system)" == "" ]
then
kubectl --kubeconfig ~/.kube/project-eumgmt-eks-eu-west-2.config create -n kube-system secret generic cilium-ipsec-keys --from-literal=keys="3 rfc4106(gcm(aes)) $(echo $(dd if=/dev/urandom count=20 bs=1 2> /dev/null | xxd -p -c 64)) 128"
fi

### Rotate key
#KEYID=$(kubectl get secret -n kube-system cilium-ipsec-keys -o yaml | awk '/^\s*keys:/ {print $2}' | base64 -d | awk '{print $1}')
#if [[ $KEYID -ge 15 ]]; then KEYID=0; fi
#data=$(echo "{\"stringData\":{\"keys\":\"$((($KEYID+1))) "rfc4106\(gcm\(aes\)\)" $(echo $(dd if=/dev/urandom count=20 bs=1 2> /dev/null| xxd -p -c 64)) 128\"}}")
#kubectl patch secret -n kube-system cilium-ipsec-keys -p="${data}" -v=1