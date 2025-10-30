## Task 2: Configure System Parameters

Kubernetes requires specific kernel parameters to be set for proper networking and operation.

### Load Required Kernel Modules

First, load the bridge and netfilter modules:

```bash
sudo modprobe br_netfilter
sudo modprobe nf_conntrack
```

Make them load on boot:

```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
nf_conntrack
EOF
```

### Configure sysctl Parameters

Configure the required kernel parameters:

```bash
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv6.conf.all.forwarding = 1
net.ipv4.ip_forward = 1
net.netfilter.nf_conntrack_max = 131072
EOF
```

### Apply the Settings

Apply the sysctl parameters without rebooting:

```bash
sudo sysctl --system
```

Or apply them individually:

```bash
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo sysctl -w net.ipv6.conf.all.forwarding=1
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.netfilter.nf_conntrack_max=131072
```

<details>
<summary>💡 Hint: What do these parameters do?</summary>

- **net.bridge.bridge-nf-call-iptables=1**  
  Enables iptables to see bridged traffic (required for Kubernetes networking)

- **net.ipv6.conf.all.forwarding=1**  
  Enables IPv6 packet forwarding

- **net.ipv4.ip_forward=1**  
  Enables IPv4 packet forwarding (required for pod-to-pod communication)

- **net.netfilter.nf_conntrack_max=131072**  
  Sets maximum number of connections to track (prevents connection tracking table overflow)

</details>

### Verify the Settings

Check each parameter:

```bash
sysctl net.bridge.bridge-nf-call-iptables
sysctl net.ipv6.conf.all.forwarding
sysctl net.ipv4.ip_forward
sysctl net.netfilter.nf_conntrack_max
```

All should show the correct values (1 or 131072).

---

**Success criteria for Task 2:**
- ✅ `net.bridge.bridge-nf-call-iptables = 1`
- ✅ `net.ipv6.conf.all.forwarding = 1`
- ✅ `net.ipv4.ip_forward = 1`
- ✅ `net.netfilter.nf_conntrack_max = 131072`

---

### Verify Complete Setup

Check all components:

```bash
# Docker
docker --version

# cri-dockerd service
systemctl status cri-docker.service | grep Active

# Sysctl parameters
sysctl net.bridge.bridge-nf-call-iptables \
       net.ipv6.conf.all.forwarding \
       net.ipv4.ip_forward \
       net.netfilter.nf_conntrack_max
```

Your system is now ready for Kubernetes installation with kubeadm!
