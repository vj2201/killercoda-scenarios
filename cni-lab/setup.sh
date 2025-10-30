#!/bin/bash
set -e

echo "[setup] CNI lab: ensuring cluster readiness"

for i in {1..90}; do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    echo "[setup] Cluster Ready"
    break
  fi
  sleep 2
done

echo "[setup] No additional pre-created resources required. Proceed to Step 1."

