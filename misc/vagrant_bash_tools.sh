#!/bin/bash

# Install kubectl - Must match with server's K8s version
KUBECTL_VERSION="1.26.2"
curl -LO https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
chmod 0755 kubectl
sudo mv kubectl /usr/local/bin

# Install kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
sudo mv kustomize /usr/local/bin/

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

# Cilium CLI
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/master/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

# Istioctl
#curl -L https://istio.io/downloadIstio | sh -
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.17.2 TARGET_ARCH=x86_64 sh -
sudo cp -rp istio-1.17.2/bin/istioctl /usr/local/bin/
rm -rf istio-1.17.2

# Velerocli
wget https://github.com/vmware-tanzu/velero/releases/download/v1.10.2/velero-v1.10.2-linux-amd64.tar.gz && tar -xf velero-v1.10.2-linux-amd64.tar.gz velero-v1.10.2-linux-amd64/velero ;
sudo mv velero-v1.10.2-linux-amd64/velero /usr/local/bin
rm -rf velero-v1.10.2-linux-amd64*

# kubectx & kubens
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo cp -rp /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo cp -rp /opt/kubectx/kubens /usr/local/bin/kubens
sudo rm -rf /opt/kubectx

# Completion for kubectx and kubens in bash
if [ ! -d ~/.kubectx ]
then
    git clone https://github.com/ahmetb/kubectx.git ~/.kubectx
fi
COMPDIR=$(pkg-config --variable=completionsdir bash-completion)
sudo ln -sf ~/.kubectx/completion/kubens.bash $COMPDIR/kubens
sudo ln -sf ~/.kubectx/completion/kubectx.bash $COMPDIR/kubectx

# Install fuzzy for interactive kubectx and kubens
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# ArgoCD install 
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64