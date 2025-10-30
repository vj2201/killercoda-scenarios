# Kubernetes System Preparation Lab

**Difficulty:** Beginner-Intermediate
**Duration:** 10-15 minutes
**CKA Exam Topics:** Cluster Architecture, Installation & Configuration

## Overview

Learn how to prepare a Linux system for Kubernetes by installing cri-dockerd and configuring kernel parameters.

## Scenario

Docker is already installed, but you need to configure the system for kubeadm cluster setup.

## Tasks

1. Install cri-dockerd from Debian package
2. Enable and start cri-docker service
3. Configure required kernel parameters for Kubernetes networking

## Key Concepts

- cri-dockerd and CRI adapters
- Debian package management (dpkg)
- systemd service management
- sysctl kernel parameter configuration
- Kubernetes prerequisites

## Lab Structure

- `setup.sh` - Installs Docker and downloads cri-dockerd package
- `step1.md` - Install and configure cri-dockerd
- `step2.md` - Configure system parameters
- `solution/` - Complete solution

---

**Part of the CKA Practice Lab Series**
https://github.com/vj2201/killercoda-scenarios
