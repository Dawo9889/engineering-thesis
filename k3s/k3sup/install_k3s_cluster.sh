#!/bin/bash
# install_k3s_cluster.sh
# Automates k3s installation using k3sup

# Variables
K3SUP="./k3sup-darwin-arm64"
SSH_KEY="$HOME/.ssh/homelab_ed25519"
KUBECONFIG_PATH="$HOME/.kube/config"
SERVER_IP="192.168.0.3"
WORKER_IP="192.168.0.6"
CONTEXT_NAME="local-k3s"

# Colors for output
GREEN="\033[0;32m"
NC="\033[0m" # No Color

echo -e "${GREEN}Installing K3s on the server (${SERVER_IP})...${NC}"
$K3SUP install \
  --host "$SERVER_IP" \
  --ssh-key "$SSH_KEY" \
  --merge \
  --context "$CONTEXT_NAME" \
  --local-path "$KUBECONFIG_PATH"

if [ $? -ne 0 ]; then
  echo "K3s server installation failed."
  exit 1
fi

echo -e "${GREEN}Joining worker node (${WORKER_IP}) to the cluster...${NC}"
$K3SUP join \
  --ip "$WORKER_IP" \
  --server-ip "$SERVER_IP" \
  --ssh-key "$SSH_KEY"

if [ $? -ne 0 ]; then
  echo "Failed to join worker node."
  exit 1
fi

echo -e "${GREEN} K3s cluster setup complete!${NC}"
echo -e "Check your contexts with: kubectl config get-contexts"
