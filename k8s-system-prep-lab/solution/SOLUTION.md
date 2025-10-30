# Kubernetes System Preparation - Complete Solution

## Task Summary

1. Install cri-dockerd from Debian package
2. Enable and start cri-docker service
3. Configure system parameters for Kubernetes

---

## Task 1: Install and Configure cri-dockerd

### Verify Docker is Installed

\`\`\`bash
docker --version
systemctl status docker
\`\`\`

### Install the cri-dockerd Package

\`\`\`bash
sudo dpkg -i ~/cri-dockerd_0.3.9.3-0.ubuntu-jammy_amd64.deb
\`\`\`

If there are dependency errors:

\`\`\`bash
sudo apt-get install -f
\`\`\`

### Enable and Start cri-docker Service

\`\`\`bash
sudo systemctl enable cri-docker.service
sudo systemctl start cri-docker.service
\`\`\`

Also enable and start the socket:

\`\`\`bash
sudo systemctl enable cri-docker.socket
sudo systemctl start cri-docker.socket
\`\`\`

### Verify Services

\`\`\`bash
systemctl status cri-docker.service
systemctl status cri-docker.socket
\`\`\`

---

## Task 2: Configure System Parameters

### Load Kernel Modules

\`\`\`bash
sudo modprobe br_netfilter
sudo modprobe nf_conntrack
\`\`\`

Make them persistent:

\`\`\`bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
nf_conntrack
EOF
\`\`\`

### Configure sysctl Parameters

Create configuration file:

\`\`\`bash
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv6.conf.all.forwarding = 1
net.ipv4.ip_forward = 1
net.netfilter.nf_conntrack_max = 131072
EOF
\`\`\`

### Apply Settings

\`\`\`bash
sudo sysctl --system
\`\`\`

Or apply individually:

\`\`\`bash
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo sysctl -w net.ipv6.conf.all.forwarding=1
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.netfilter.nf_conntrack_max=131072
\`\`\`

### Verify Configuration

\`\`\`bash
sysctl net.bridge.bridge-nf-call-iptables
sysctl net.ipv6.conf.all.forwarding
sysctl net.ipv4.ip_forward
sysctl net.netfilter.nf_conntrack_max
\`\`\`

Expected output:
\`\`\`
net.bridge.bridge-nf-call-iptables = 1
net.ipv6.conf.all.forwarding = 1
net.ipv4.ip_forward = 1
net.netfilter.nf_conntrack_max = 131072
\`\`\`

---

## Verification Checklist

\`\`\`bash
# Check Docker
docker --version

# Check cri-dockerd
systemctl is-enabled cri-docker.service
systemctl is-active cri-docker.service

# Check sysctl parameters
sysctl net.bridge.bridge-nf-call-iptables \
       net.ipv6.conf.all.forwarding \
       net.ipv4.ip_forward \
       net.netfilter.nf_conntrack_max
\`\`\`

Success criteria:
- ✅ Docker is installed and running
- ✅ cri-docker.service is enabled and active
- ✅ cri-docker.socket is enabled and active
- ✅ All sysctl parameters are set correctly

---

## What Each Component Does

**cri-dockerd:**
- CRI (Container Runtime Interface) adapter for Docker
- Required since Kubernetes v1.24 removed dockershim
- Allows kubeadm to use Docker as container runtime

**net.bridge.bridge-nf-call-iptables:**
- Enables iptables processing of bridged packets
- Required for Kubernetes pod networking

**net.ipv6.conf.all.forwarding:**
- Enables IPv6 packet forwarding
- Needed for IPv6 pod communication

**net.ipv4.ip_forward:**
- Enables IPv4 packet forwarding
- Essential for pod-to-pod and pod-to-service communication

**net.netfilter.nf_conntrack_max:**
- Maximum connection tracking entries
- Prevents connection table overflow in busy clusters

---

## Common Issues

**Issue: dpkg dependency errors**

Solution:
\`\`\`bash
sudo apt-get install -f
\`\`\`

**Issue: Module br_netfilter not found**

Solution:
\`\`\`bash
sudo apt-get update
sudo apt-get install -y linux-modules-extra-$(uname -r)
sudo modprobe br_netfilter
\`\`\`

**Issue: sysctl parameter not found**

Ensure modules are loaded first:
\`\`\`bash
sudo modprobe br_netfilter
sudo modprobe nf_conntrack
\`\`\`

---

## CKA Exam Tips

1. **Package installation**: Know both \`dpkg -i\` and \`apt install\`
2. **Service management**: Practice systemctl enable/start/status
3. **sysctl configuration**: Remember to apply with \`--system\` or \`-w\`
4. **Persistence**: Configure files in /etc/ for settings to survive reboot
5. **Verification**: Always verify each step before proceeding

---

**Congratulations!** Your system is now ready for Kubernetes installation with kubeadm.
