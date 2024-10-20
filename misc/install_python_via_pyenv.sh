#!/bin/bash

# Install the latest Python version via pyenv
#PYTHON_VERSION=$(pyenv install --list | grep -E "^\s*[0-9]+\.[0-9]+\.[0-9]+$" | tail -1 | tr -d ' ')
export PYTHON_VERSION=3.13.0
pyenv install $PYTHON_VERSION

# Set the latest Python version as the global default
pyenv global $PYTHON_VERSION

# Create a virtual environment
pyenv virtualenv $PYTHON_VERSION venv${PYTHON_VERSION}

# Define the string to check and append
STRING_TO_CHECK='export PYTHON_VERSION=3.12.2'
STRING_TO_APPEND='export PYTHON_VERSION=3.12.2\npyenv activate venv${PYTHON_VERSION}'

# Check if the string appears in .bashrc
if ! grep -q "$STRING_TO_CHECK" ~/.bashrc; then
    # Append the string to .bashrc
    echo -e "$STRING_TO_APPEND" >> ~/.bashrc
fi

source ~/.bashrc

# Verify installation
python --version