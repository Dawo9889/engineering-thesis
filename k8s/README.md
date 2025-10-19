```
#!/bin/bash
set -e

# =========================
# Aktualizacja systemu
# =========================
sudo apt update && sudo apt upgrade -y

# =========================
# Wyłączenie swap
# =========================
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# =========================
# Wymagane moduły kernela
# =========================
sudo modprobe overlay
sudo modprobe br_netfilter

# =========================
# Sysctl
# =========================
cat <<EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

# =========================
# Instalacja containerd
# =========================
sudo apt install -y apt-transport-https curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt update
sudo apt install -y containerd.io

# Konfiguracja containerd na systemd cgroups
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

# =========================
# Instalacja Kubernetes
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
echo "Instalacja zakończona pomyślnie!"
echo "Możesz teraz uruchomić kubeadm init."
echo "===================================="

```


## Inicjalizacja klastra control node 1
```
sudo kubeadm init --control-plane-endpoint "192.168.0.10:6443" \
  --upload-certs \
  --pod-network-cidr=10.244.0.0/16
```

## Inicjalizacja calico, który pozwala na komunikacje podow na roznych node'ach
```
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.30.4/manifests/operator-crds.yaml  
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.30.4/manifests/tigera-operator.yaml
```

```
curl https://raw.githubusercontent.com/projectcalico/calico/v3.30.4/manifests/custom-resources.yaml -O
```
Zmień pod network na ten podany podczas inicjalizacji klastra
```
    - name: default-ipv4-ippool
      blockSize: 26
      cidr: 192.168.0.0/16
```


## Dołaczenie innych control node (komende skopiowac z outputu control node1)
```
  kubeadm join 192.168.0.10:6443 --token c698et.4merh255qkaj50wz \                                                                              

        --discovery-token-ca-cert-hash sha256:e005379127778e34cf121066f1e637ae73ef6f392d8ecccdcbf5a523e922def2 \                                

        --control-plane --certificate-key a21ba7adabf6599036c5adc618f7554dc007c34fa279599de12b865642ad686d
```

## Dołączanie worker nodes (komende skopiowac z outputu control node 1)
```
kubeadm join 192.168.0.10:6443 --token c698et.4merh255qkaj50wz \                                    
    --discovery-token-ca-cert-hash sha256:e005379127778e34cf121066f1e637ae73ef6f392d8ecccdcbf5a523e922def2
```

