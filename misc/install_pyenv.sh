#!/bin/bash

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses-dev xz-utils tk-dev libffi-dev liblzma-dev git

# Clean up existing pyenv installation
rm -rf ~/.pyenv
# Install pyenv
curl https://pyenv.run | bash

# Add pyenv to bashrc for interactive shells if PYENV_ROOT is not already set
if ! grep -q 'export PYENV_ROOT="$HOME/.pyenv"' ~/.bashrc; then
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
  echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
  echo 'eval "$(pyenv init -)"' >> ~/.bashrc
  echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
fi

if ! grep -q 'eval "$(pyenv virtualenv-init -)"' ~/.bashrc; then
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
fi

source ~/.bashrc

./install_python_via_pyenv.sh