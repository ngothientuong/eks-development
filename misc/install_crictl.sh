#!/bin/bash

# Download the latest crictl release
VERSION=$(curl -s https://api.github.com/repos/kubernetes-sigs/cri-tools/releases/latest | grep tag_name | cut -d '"' -f 4)
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz

# Extract the tarball
tar zxvf crictl-$VERSION-linux-amd64.tar.gz

# Move crictl to /usr/local/bin
sudo mv crictl /usr/local/bin/

rm -rf crictl-$VERSION-linux-amd64.tar.gz
# Verify installation
crictl --version