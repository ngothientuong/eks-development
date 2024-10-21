#!/bin/bash

# Get script dir
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo ln -s ~/ngo /ngo
mkdir -p /ngo/misc/packages
cd /ngo/misc/packages

# Install kubectl - Must match with server's K8s version
KUBECTL_VERSION="1.31.1"
curl -LO https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
chmod 0755 kubectl
sudo mv kubectl /usr/local/bin

# Install kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
sudo mv kustomize /usr/local/bin/

## Disable due to no access to aws
# aws eks update-kubeconfig --region us-east-2 --name project-mgmt-eks-cluster-int-2
# aws eks update-kubeconfig --region us-east-2 --name project-mgmt-eks-cluster-int-test
# aws eks update-kubeconfig --region us-east-2 --name project-mgmt-eks-cluster-rancher-test
# aws eks update-kubeconfig --region eu-west-2 --name project-eumgmt-eks-eu-west-2

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
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.23.2 TARGET_ARCH=x86_64 sh -
sudo cp -rp istio-1.23.2/bin/istioctl /usr/local/bin/
rm -rf istio-1.23.2

# Velerocli
wget https://github.com/vmware-tanzu/velero/releases/download/v1.14.0/velero-v1.14.0-linux-amd64.tar.gz && tar -xf velero-v1.14.0-linux-amd64.tar.gz velero-v1.14.0-linux-amd64/velero ;
sudo mv velero-v1.14.0-linux-amd64/velero /usr/local/bin
rm -rf velero-v1.14.0-linux-amd64*

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

# Copy .bashrc and .vimrc to home directory
cp -rp ./.bashrc ~/.bashrc
cp -rp ./.vimrc ~/.vimrc

# ArgoCD install
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

# Install Go 1.21
export GO_VERSION=1.23.1
mkdir -p /ngo/misc/packages
cd /ngo/misc/packages
#rm -rf go${GO_VERSION}.linux-amd64.tar.gz
rm -rf go*.linux-amd64.tar.gz
wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
# Find package of a type

# Install minikube for learning
mkdir -p /ngo/misc/packages
cd /ngo/misc/packages
rm -rf minikube-linux-amd64
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube


# Install kubebuilder
# download kubebuilder and install locally.
curl -L -o kubebuilder "https://go.kubebuilder.io/dl/latest/$(go env GOOS)/$(go env GOARCH)"
chmod +x kubebuilder && sudo mv kubebuilder /usr/local/bin/

# Install Operator SKD CLI
export ARCH=$(case $(uname -m) in x86_64) echo -n amd64 ;; aarch64) echo -n arm64 ;; *) echo -n $(uname -m) ;; esac)
export OS=$(uname | awk '{print tolower($0)}')
export OPERATOR_SDK_DL_URL=https://github.com/operator-framework/operator-sdk/releases/download/v1.33.0
curl -LO ${OPERATOR_SDK_DL_URL}/operator-sdk_${OS}_${ARCH}
gpg --keyserver keyserver.ubuntu.com --recv-keys 052996E2A20B5C7E
curl -LO ${OPERATOR_SDK_DL_URL}/checksums.txt
curl -LO ${OPERATOR_SDK_DL_URL}/checksums.txt.asc
gpg -u "Operator SDK (release) <cncf-operator-sdk@cncf.io>" --verify checksums.txt.asc
grep operator-sdk_${OS}_${ARCH} checksums.txt | sha256sum -c -


cd $SCRIPT_DIR
# Install Docker
# Follow the doc here: https://docs.docker.com/engine/install/ubuntu/#install-from-a-package
# Run the below before adding running minikube
# Restart Windows OS if used in WSL
./docker_install.sh
# Install python3 via pyenv
./install_pyenv.sh
# Configure git profile
./configure_git_profile.sh


# Python Package
pip install numpy

# Clean up
rm -rf /ngo/misc/packages/*