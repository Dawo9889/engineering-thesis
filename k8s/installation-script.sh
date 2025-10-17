#!/bin/bash
set -e

# =========================
# System update
# =========================
sudo apt update && sudo apt upgrade -y

# =========================
# Disable swap
# =========================
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# =========================
# Required kernel modules
# =========================
sudo modprobe overlay
sudo modprobe br_netfilter

# =========================
# Sysctl configuration
# =========================
cat <<EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

# =========================
# Install containerd
# =========================
sudo apt install -y apt-transport-https curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt update
sudo apt install -y containerd.io

# Configure containerd to use systemd cgroups
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

# =========================
# Install Kubernetes
# =========================
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# Add Kubernetes APT key
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes repository
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update repo and install Kubernetes packages
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

# Prevent automatic upgrades
sudo apt-mark hold kubelet kubeadm kubectl

echo "===================================="
echo "Installation completed successfully!"
echo "You can now run kubeadm init."
echo "===================================="
