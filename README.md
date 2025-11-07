# CKA Practice Labs - Killercoda Format

[![Killercoda](https://img.shields.io/badge/Platform-Killercoda-orange)](https://killercoda.com)
[![CKA](https://img.shields.io/badge/Exam-CKA-blue)](https://www.cncf.io/certification/cka/)
[![Labs](https://img.shields.io/badge/Labs-14-green)](https://github.com/mjai2201/cka-practice-labs)

**Interactive Kubernetes CKA exam practice labs in official Killercoda multi-step format with automated verification.**

---

## 🎯 Overview

This repository contains **14 hands-on Kubernetes labs** designed for CKA (Certified Kubernetes Administrator) exam preparation. Each lab follows the official Killercoda format with:

- ✅ **Multi-step learning** - Progressive task breakdown
- ✅ **Automated verification** - Instant feedback on each step
- ✅ **CKA exam topics** - Covers all certification domains
- ✅ **Ready to upload** - Compatible with killercoda.com platform

---

## 📚 Available Labs

| Lab | Topic | Difficulty | Steps |
|-----|-------|-----------|-------|
| [cert-manager-lab](./cert-manager-lab) | Install cert-manager CRDs | Intermediate | 2 |
| [cni-lab](./cni-lab) | Compare Calico vs Flannel | Advanced | 2 |
| [cri-docker-scenrio](./cri-docker-scenrio) | Install CRI-Docker runtime | Intermediate | 2 |
| [gateway-migration-lab](./gateway-migration-lab) | Migrate Ingress → Gateway API | Advanced | 2 |
| [hpa-lab](./hpa-lab) | Configure HorizontalPodAutoscaler | Intermediate | 2 |
| [ingress-lab](./ingress-lab) | Set up Ingress controller | Intermediate | 2 |
| [mariadb-pvc-lab](./mariadb-pvc-lab) | Recover MariaDB with PVC | Intermediate | 2 |
| [network-policy-lab](./network-policy-lab) | Configure NetworkPolicy | **Advanced** | **3** ⭐ |
| [nodeport-lab](./nodeport-lab) | Expose services via NodePort | Beginner | 2 |
| [priority-lab](./priority-lab) | Configure PriorityClass | Intermediate | 2 |
| [resources-lab-q04](./resources-lab-q04) | Set resource requests/limits | Beginner | 2 |
| [sidecar-lab](./sidecar-lab) | Implement sidecar pattern | Intermediate | 2 |
| [taints-tolerations-lab](./taints-tolerations-lab) | Configure taints & tolerations | Intermediate | 2 |
| [tls-config-lab](./tls-config-lab) | Configure TLS protocols | Intermediate | 2 |

⭐ **Featured Lab:** `network-policy-lab` includes detailed step-by-step content as a reference example.

---

## 🚀 Quick Start

### Option 1: Use on Killercoda (Recommended)

1. **Upload to Killercoda:**
   - Go to [killercoda.com/creators](https://killercoda.com/creators)
   - Create an account
   - Upload a lab directory (e.g., `network-policy-lab/`)
   - Test and publish!

2. **Share with students:**
   - Get your Killercoda profile URL
   - Students can access labs directly in browser
   - No Kubernetes cluster needed!

### Option 2: Run Locally

```bash
# 1. Create a Kubernetes cluster
kind create cluster --name cka-practice

# 2. Choose a lab
cd network-policy-lab

# 3. Run background setup
bash background.sh

# 4. Follow the steps
cat step1/text.md
# ... complete the task ...
bash step1/verify.sh  # Verify your work

cat step2/text.md
# ... complete the task ...
bash step2/verify.sh  # Verify your work
```

---

## 📁 Lab Structure

Each lab follows the official Killercoda format:

```
lab-name/
├── index.json          # Killercoda scenario configuration
├── intro.md            # Introduction and objectives
├── background.sh       # Setup script (runs automatically)
├── step1/
│   ├── text.md        # Step 1 instructions
│   └── verify.sh      # Step 1 verification script
├── step2/
│   ├── text.md        # Step 2 instructions
│   └── verify.sh      # Step 2 verification script
└── finish.md           # Congratulations and summary
```

---

## 🎓 CKA Exam Coverage

These labs cover all CKA exam domains:

| Domain | Weight | Labs |
|--------|--------|------|
| **Cluster Architecture, Installation & Configuration** | 25% | cert-manager, cri-docker, cni |
| **Workloads & Scheduling** | 15% | priority, taints-tolerations, resources, sidecar |
| **Services & Networking** | 20% | ingress, gateway-migration, network-policy, nodeport |
| **Storage** | 10% | mariadb-pvc |
| **Troubleshooting** | 30% | *All labs include troubleshooting* |

---

## ✨ Features

- **Multi-step learning** - Complex tasks broken into manageable steps
- **Automated verification** - Instant feedback with `verify.sh` scripts
- **Killercoda ready** - Matches [official examples](https://github.com/killercoda/scenario-examples)
- **Production quality** - Detailed explanations, commands, and troubleshooting tips

---

## 🔒 Security & Compliance

✅ **Verified Clean:** No cryptominers, security scanners, or prohibited tools
✅ **Killercoda Compliant:** Safe for educational use, platform-ready
✅ **Educational Content:** Only legitimate Kubernetes commands

---

## 📖 Documentation

- **[REPO_STRUCTURE.md](./REPO_STRUCTURE.md)** - Detailed format documentation
- **[Killercoda Creator Docs](https://killercoda.com/creators)** - Platform documentation
- **[CKA Curriculum](https://github.com/cncf/curriculum)** - Official exam topics

---

## 💡 Support

**Enjoying these free CKA labs?**

- ⭐ Star this repository
- 🔔 [Subscribe on YouTube](https://youtube.com/channel/UC2ckWW5aAtV0KISxk6g8rCg?sub_confirmation=1)
- ☕ [Buy me a coffee](https://buymeacoffee.com/vjaarohi)

---

**Happy Learning! Good luck on your CKA exam! 🚀**

