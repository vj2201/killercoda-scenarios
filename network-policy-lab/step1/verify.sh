#!/bin/bash

# Verify that user has inspected the resources
# Check if backend deployment exists
kubectl get deployment backend -n backend > /dev/null 2>&1 || exit 1

# Check if frontend namespace exists
kubectl get namespace frontend > /dev/null 2>&1 || exit 1

# Check if backend service exists
kubectl get svc backend-service -n backend > /dev/null 2>&1 || exit 1

echo "done"
