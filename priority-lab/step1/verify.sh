#!/bin/bash
# Basic verification - cluster is ready
kubectl get nodes > /dev/null 2>&1 || exit 1
echo "done"
