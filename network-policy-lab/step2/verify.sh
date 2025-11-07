#!/bin/bash

# Verify NetworkPolicy was created correctly
kubectl get networkpolicy backend-network-policy -n backend > /dev/null 2>&1 || exit 1

# Check that it has the correct podSelector
kubectl get networkpolicy backend-network-policy -n backend -o jsonpath='{.spec.podSelector.matchLabels.app}' | grep -q "backend" || exit 1

# Check that it has the correct port
kubectl get networkpolicy backend-network-policy -n backend -o jsonpath='{.spec.ingress[0].ports[0].port}' | grep -q "8080" || exit 1

echo "done"
