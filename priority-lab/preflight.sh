#!/bin/sh
set -e

echo "=== preflight start (priority-lab): $(date) ==="
kubectl version || true

for i in $(seq 1 60); do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    break
  fi
  sleep 2
done

if kubectl get ns priority >/dev/null 2>&1; then
  echo "[info] priority namespace present"
else
  if [ -x /root/setup.sh ]; then
    bash /root/setup.sh || true
  elif [ -x /root/background.sh ]; then
    bash /root/background.sh || true
  fi
fi

# Ensure user-defined PriorityClasses exist (avoid race with background setup)
if ! kubectl get priorityclass medium-priority >/dev/null 2>&1 || ! kubectl get priorityclass normal-priority >/dev/null 2>&1; then
  kubectl apply -f - <<'YAML' || true
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: medium-priority
value: 1000
globalDefault: false
description: "Medium priority for important workloads"
---
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: normal-priority
value: 500
globalDefault: false
description: "Normal priority for regular workloads"
YAML
fi

kubectl get deploy,po -n priority || true
echo "=== preflight end (priority-lab): $(date) ==="
