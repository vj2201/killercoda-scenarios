#!/bin/bash

# Test connectivity from frontend to backend (should succeed)
FRONTEND_POD=$(kubectl get pod -n frontend -l app=frontend -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)

if [ -z "$FRONTEND_POD" ]; then
  echo "Frontend pod not found"
  exit 1
fi

# Try to connect from frontend to backend
kubectl exec -n frontend $FRONTEND_POD -- wget -qO- --timeout=5 http://backend-service.backend:8080 > /dev/null 2>&1 || exit 1

echo "done"
