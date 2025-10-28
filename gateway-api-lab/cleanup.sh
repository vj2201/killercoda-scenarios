#!/bin/bash
set -euo pipefail

echo "[cleanup] Removing Gateway API migration lab resources"

ns=web-migration

echo "[cleanup] Deleting Gateway/HTTPRoute if present"
kubectl -n "$ns" delete httproute web-route --ignore-not-found
kubectl -n "$ns" delete gateway web-gateway --ignore-not-found

echo "[cleanup] Deleting namespace $ns (includes Deployments, Services, Ingress, Secret)"
kubectl delete ns "$ns" --ignore-not-found

echo "[cleanup] Done"

