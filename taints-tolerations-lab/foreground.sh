#!/bin/bash
set -e

echo "⏳ Preparing 2-node Kubernetes cluster..."
echo "   This may take 1-2 minutes..."
echo ""

# Wait for both nodes to be ready
while true; do
  NODE_COUNT=$(kubectl get nodes --no-headers 2>/dev/null | wc -l)
  if [ "$NODE_COUNT" -ge 2 ]; then
    READY_COUNT=$(kubectl get nodes --no-headers 2>/dev/null | grep -c " Ready " || true)
    if [ "$READY_COUNT" -ge 2 ]; then
      break
    fi
  fi
  sleep 3
done

echo ""
echo "✅ Cluster ready!"
echo ""
kubectl get nodes
echo ""
echo "You can now start the task."
echo ""
