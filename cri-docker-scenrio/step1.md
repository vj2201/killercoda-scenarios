## Task 1: Install and Configure cri-dockerd

### Verify Docker is Installed

```bash
docker --version
systemctl status docker
```

### Verify the Package Exists

```bash
ls -lh ~/cri-dockerd_0.3.9.3-0.ubuntu-jammy_amd64.deb
```

### Install the cri-dockerd Package

Use `dpkg` to install Debian packages:

```bash
sudo dpkg -i ~/cri-dockerd_0.3.9.3-0.ubuntu-jammy_amd64.deb
```

If there are dependency issues, fix them with:

```bash
sudo apt-get install -f
```

<details>
<summary>💡 Hint: What is cri-dockerd?</summary>

**cri-dockerd** is a CRI (Container Runtime Interface) adapter for Docker Engine.

- Kubernetes removed built-in Docker support in v1.24
- cri-dockerd provides the CRI interface between Kubernetes and Docker
- Required if you want to use Docker as the container runtime with kubeadm

</details>

### Enable and Start the cri-docker Service

Enable the service to start on boot:

```bash
sudo systemctl enable cri-docker.service
```

Start the service:

```bash
sudo systemctl start cri-docker.service
```

### Verify the Service is Running

```bash
systemctl status cri-docker.service
```

You should see `Active: active (running)`.

Also enable and start the socket:

```bash
sudo systemctl enable cri-docker.socket
sudo systemctl start cri-docker.socket
systemctl status cri-docker.socket
```

---

**Success criteria for Task 1:**
- ✅ cri-dockerd package is installed
- ✅ cri-docker.service is enabled and active
- ✅ cri-docker.socket is enabled and active
