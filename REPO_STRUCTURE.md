# CKA Practice Labs - Killercoda Format

## ✅ Security Audit Completed

**All 14 labs have been scanned and verified clean:**
- ❌ NO cryptominers
- ❌ NO security scanners
- ❌ NO bruteforce tools
- ❌ NO hacker tools
- ❌ NO network stress tools
- ✅ Only legitimate Kubernetes educational content

## 📁 Killercoda Multi-Step Structure

Each lab now follows **official Killercoda format**:

```
lab-name/
├── index.json          # Killercoda scenario configuration
├── intro.md            # Introduction and scenario overview
├── background.sh       # Setup script (runs in background)
├── step1/
│   ├── text.md        # Step 1 instructions
│   └── verify.sh      # Step 1 verification script
├── step2/
│   ├── text.md        # Step 2 instructions
│   └── verify.sh      # Step 2 verification script
└── finish.md           # Congratulations message
```

## 📚 Available Labs (14 total)

1. **cert-manager-lab** - Install and configure cert-manager CRDs
2. **cni-lab** - Compare Calico vs Flannel CNI plugins
3. **cri-docker-scenrio** - Install CRI-Docker runtime
4. **gateway-migration-lab** - Migrate from Ingress to Gateway API
5. **hpa-lab** - Configure HorizontalPodAutoscaler
6. **ingress-lab** - Set up Ingress controller and rules
7. **mariadb-pvc-lab** - Recover MariaDB data using PVC
8. **network-policy-lab** - Configure NetworkPolicy for pod isolation ⭐ *Detailed example*
9. **nodeport-lab** - Expose services via NodePort
10. **priority-lab** - Configure PriorityClass for pod scheduling
11. **resources-lab-q04** - Set resource requests/limits
12. **sidecar-lab** - Implement sidecar container pattern
13. **taints-tolerations-lab** - Configure node taints and tolerations
14. **tls-config-lab** - Configure TLS protocol versions

## 🚀 How to Use on Killercoda

### Upload to Killercoda.com

1. **Create an account** at [killercoda.com/creators](https://killercoda.com/creators)
2. **Upload a lab directory** (e.g., network-policy-lab/)
3. **Test the scenario** in the Killercoda editor
4. **Publish** when ready!

### Test Locally

You can still test labs locally:

```bash
# 1. Create a Kubernetes cluster
kind create cluster --name cka-practice

# 2. Choose a lab
cd network-policy-lab

# 3. Run setup
bash background.sh

# 4. Follow steps manually
cat step1/text.md
# ... do the task ...
bash step1/verify.sh  # Check if correct

cat step2/text.md
# ... do the task ...
bash step2/verify.sh  # Check if correct
```

## 📝 File Contents Explained

### index.json
```json
{
  "title": "Lab Title",
  "description": "Lab description",
  "details": {
    "intro": {
      "text": "intro.md",
      "background": "background.sh"
    },
    "steps": [
      {
        "title": "Step Title",
        "text": "step1/text.md",
        "verify": "step1/verify.sh"
      }
    ],
    "finish": {
      "text": "finish.md"
    }
  },
  "backend": {
    "imageid": "kubernetes-kubeadm-2nodes"
  }
}
```

### intro.md
- Lab scenario description
- Learning objectives
- Task overview
- Success criteria

### step*/text.md
- Detailed step instructions
- Commands to run
- Expected outputs
- Tips and explanations

### step*/verify.sh
- Automated verification script
- Checks if step was completed correctly
- Returns "done" on success, exits with error on failure

### background.sh
- Environment setup script
- Creates namespaces, deployments, services
- Runs automatically when lab starts
- Waits for resources to be ready

### finish.md
- Congratulations message
- Summary of what was learned
- Key takeaways
- CKA exam tips
- Additional resources

## 🎓 Multi-Step Learning Flow

Killercoda's multi-step format provides:

✅ **Progressive learning** - Break complex tasks into manageable steps
✅ **Automated verification** - Check work at each step before proceeding
✅ **Interactive feedback** - Know immediately if you did it right
✅ **Guided experience** - Clear instructions at each stage
✅ **CKA exam prep** - Practice with verification like the real exam

## 🔧 Backend Configurations

Different labs use different backends:

- **kubernetes-kubeadm-2nodes** (most labs)
  - 2-node Kubernetes cluster
  - controlplane + node01
  - Used for: NetworkPolicy, Taints, Gateway API, etc.

- **ubuntu** (cri-docker-scenrio)
  - Plain Ubuntu VM
  - For installation/setup tasks
  - Used for: CRI installation, system-level configs

## ⭐ Example: network-policy-lab

The `network-policy-lab` has detailed step content as a reference:

- **Step 1:** Discover labels and ports through inspection
- **Step 2:** Create NetworkPolicy with discovered values
- **Step 3:** Test network isolation with connectivity tests

Other labs have basic structure you can enhance with content from the original solutions.

## 🔄 Converting from Old Format

**Old format (3 files):**
```
lab-name/
├── setup.sh
├── question
└── solution
```

**New format (Killercoda multi-step):**
```
lab-name/
├── index.json
├── intro.md
├── background.sh
├── step1/
│   ├── text.md
│   └── verify.sh
├── step2/
│   ├── text.md
│   └── verify.sh
└── finish.md
```

## 🎯 CKA Exam Relevance

All labs cover official CKA exam topics:
- **25%** - Cluster Architecture, Installation & Configuration
- **15%** - Workloads & Scheduling
- **20%** - Services & Networking
- **10%** - Storage
- **30%** - Troubleshooting

## 🔒 Safety Guarantees

- All commands are standard kubectl/curl/wget
- No external scanning or attacks
- All resources are self-contained
- Safe for educational environments
- No malicious code or prohibited tools
- Killercoda-compliant (no violating terms)

## 📊 Statistics

- **Total labs:** 14
- **Total files:** 130+ (avg 9-10 per lab)
- **Security issues:** 0
- **Prohibited tools:** 0
- **Killercoda-ready:** ✅ Yes

## 🆕 What's New in Killercoda Format

✅ **Multi-step progression** with verification
✅ **Automated checking** at each step
✅ **Better learning experience** with guided steps
✅ **Platform-ready** for killercoda.com upload
✅ **Verification scripts** for each step
✅ **Proper backend selection** per lab type

## 🤝 Comparison with Killercoda Examples

Our format matches [killercoda/scenario-examples](https://github.com/killercoda/scenario-examples):

| **Feature** | **Our Labs** | **Killercoda Examples** |
|-------------|-------------|------------------------|
| index.json | ✅ Yes | ✅ Yes |
| Multi-step | ✅ Yes (2-3 steps) | ✅ Yes |
| Verification | ✅ verify.sh per step | ✅ verify.sh per step |
| Background setup | ✅ background.sh | ✅ background.sh |
| Intro/Finish | ✅ Yes | ✅ Yes |

## 📖 Additional Resources

- [Killercoda Creator Docs](https://killercoda.com/creators)
- [Scenario Examples Repo](https://github.com/killercoda/scenario-examples)
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [CKA Exam Curriculum](https://github.com/cncf/curriculum)

---

Last updated: 2025-11-08
Repository: killercoda-scenarios
Format version: Killercoda multi-step
Status: Ready for upload to killercoda.com
