#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

# Install uv for python dependency management
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
# Install fuzzy finder
sudo apt install fzf
source /usr/share/doc/fzf/examples/key-bindings.bash

sudo snap install nvim --classic

# In order to create the rock, you need to install Rockcraft with classic confinement, which grants it access to the whole file system:
sudo snap install docker
sudo snap install rockcraft --channel latest/edge --classic
#
# LXD will be required for building the rock. Make sure it is installed and initialized:
# If LXD is not installed, install it
sudo snap install lxd
lxd --version
lxd init --auto

# In order to create the charm, you’ll need to install Charmcraft:

sudo snap install charmcraft --channel latest/edge --classic

sudo snap install microk8s --channel 1.31-strict/stable
sudo adduser "${USER}" snap_microk8s
newgrp snap_microk8s

# Required for Juju to provide storage volumes
sudo microk8s enable hostpath-storage
# Required to host the OCI image of the application
sudo microk8s enable registry
# Required to expose the application
sudo microk8s enable ingress

sudo microk8s status --wait-ready

sudo snap install juju --channel 3.6/stable
mkdir -p ~/.local/share
juju bootstrap microk8s dev-controller
