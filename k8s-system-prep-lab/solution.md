# Solution

## Step 1: Install cri-dockerd
```bash
dpkg -i ~/cri-dockerd.deb
systemctl enable cri-docker
systemctl start cri-docker
systemctl status cri-docker
```

## Step 2: Configure Kernel Parameters
```bash
cat > /etc/sysctl.d/99-kubernetes.conf << EOF
net.bridge.bridge-nf-call-iptables = 1
net.ipv6.conf.all.forwarding = 1
net.ipv4.ip_forward = 1
net.netfilter.nf_conntrack_max = 131072
EOF
sysctl --system
sysctl -a | grep -E "bridge-nf-call-iptables|ipv6.conf.all.forwarding|ip_forward|nf_conntrack_max"
```

## Explanation
cri-dockerd acts as a bridge between Docker and Kubernetes CRI interface (required since k8s 1.24). Kernel parameters enable packet forwarding and bridge filtering needed for pod networking and service communication.

✅ **Done!** System is prepared for Kubernetes cluster setup.
