#!/bin/bash
# install_k3s_cluster.sh
# Automates K3s setup + MetalLB + NGINX Ingress installation

# ==== CONFIGURATION ====
K3SUP="./k3sup-darwin-arm64"
SSH_KEY="$HOME/.ssh/homelab_ed25519"
KUBECONFIG_PATH="$HOME/.kube/config"
SERVER_IP="192.168.0.3"
WORKER_IP="192.168.0.6"
CONTEXT_NAME="local-k3s"
METALLB_IP_RANGE="192.168.0.150-192.168.0.160"  # Adjust for your LAN
# ========================

GREEN="\033[0;32m"
NC="\033[0m"

set -e  # Stop if any command fails

echo -e "${GREEN}🚀 Installing K3s server on ${SERVER_IP}...${NC}"
$K3SUP install \
  --host "$SERVER_IP" \
  --ssh-key "$SSH_KEY" \
  --merge \
  --context "$CONTEXT_NAME" \
  --local-path "$KUBECONFIG_PATH" \
  --k3s-extra-args '--disable traefik'

echo -e "${GREEN}🔗 Joining worker node ${WORKER_IP}...${NC}"
$K3SUP join \
  --ip "$WORKER_IP" \
  --server-ip "$SERVER_IP" \
  --ssh-key "$SSH_KEY"

# Switch to the new context
export KUBECONFIG="$KUBECONFIG_PATH"
kubectl config use-context "$CONTEXT_NAME"

# === Install MetalLB ===
echo -e "${GREEN}⚙️  Installing MetalLB...${NC}"
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml

# Wait until MetalLB components are ready
echo -e "${GREEN}⏳ Waiting for MetalLB controller and speaker to be ready...${NC}"
kubectl wait --namespace metallb-system \
  --for=condition=available deployment/controller --timeout=120s
kubectl wait --namespace metallb-system \
  --for=condition=ready pod -l component=speaker --timeout=120s

# Create an IPAddressPool for MetalLB
cat <<EOF | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: default-address-pool
  namespace: metallb-system
spec:
  addresses:
  - ${METALLB_IP_RANGE}
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: default
  namespace: metallb-system
EOF

# === Install NGINX Ingress Controller ===
echo -e "${GREEN}🌐 Installing NGINX Ingress Controller...${NC}"

# Add NGINX repo and install
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.service.type=LoadBalancer

# Wait for NGINX to be ready
echo -e "${GREEN}⏳ Waiting for ingress-nginx controller to be ready...${NC}"
kubectl wait --namespace ingress-nginx \
  --for=condition=available deployment/ingress-nginx-controller --timeout=180s

echo -e "${GREEN} K3s + MetalLB + NGINX Ingress installation complete!${NC}"
echo -e "Check LoadBalancer IP with: kubectl get svc -n ingress-nginx"

echo "Installing cert-manager"
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.19.1/cert-manager.yaml

echo -e "${GREEN}⏳ Waiting for cert-manager deployments to be ready...${NC}"
# Wait for cert-manager core components: controller, cainjector and webhook
kubectl wait --namespace cert-manager \
  --for=condition=available deployment/cert-manager --timeout=180s
kubectl wait --namespace cert-manager \
  --for=condition=available deployment/cert-manager-cainjector --timeout=180s
kubectl wait --namespace cert-manager \
  --for=condition=available deployment/cert-manager-webhook --timeout=180s

echo "Applying ClusterIssuer"
kubectl apply -f ../clusterIssuer.yaml


echo -e "${GREEN}⏳ Installing CloudNativePG (operator)...${NC}"
kubectl apply -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.17/releases/cnpg-1.17.5.yaml

