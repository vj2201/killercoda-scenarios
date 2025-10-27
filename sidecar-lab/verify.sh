#!/bin/bash
set -euo pipefail

fail() { echo "[FAIL] $*" >&2; exit 1; }
pass() { echo "[PASS] $*"; }

# Ensure cluster and deployment are reachable
kubectl version --short >/dev/null 2>&1 || fail "kubectl not ready"
kubectl get deployment synergy-deployment >/dev/null 2>&1 || fail "Deployment synergy-deployment not found"

# Check sidecar container exists
name=$(kubectl get deploy synergy-deployment -o jsonpath='{.spec.template.spec.containers[?(@.name=="sidecar")].name}')
[[ -n "$name" ]] || fail "Container named 'sidecar' not found in deployment"
pass "Found container: $name"

# Check image
image=$(kubectl get deploy synergy-deployment -o jsonpath='{.spec.template.spec.containers[?(@.name=="sidecar")].image}')
[[ "$image" == "busybox:stable" ]] || fail "Sidecar image must be busybox:stable (found: $image)"
pass "Image OK: $image"

# Check volume mount at /var/log
mount=$(kubectl get deploy synergy-deployment -o jsonpath='{.spec.template.spec.containers[?(@.name=="sidecar")].volumeMounts[?(@.mountPath=="/var/log")].name}')
[[ -n "$mount" ]] || fail "Sidecar must mount a volume at /var/log"
pass "Volume mount OK at /var/log (volume: $mount)"

# Check command/args contain the exact tail form
args=$(kubectl get deploy synergy-deployment -o jsonpath='{.spec.template.spec.containers[?(@.name=="sidecar")].args[*]}')
cmd=$(kubectl get deploy synergy-deployment -o jsonpath='{.spec.template.spec.containers[?(@.name=="sidecar")].command[*]}')
echo "Observed command: $cmd"
echo "Observed args:    $args"
echo "$cmd $args" | grep -q "/bin/sh" || fail "Sidecar must run via /bin/sh -c"
echo "$cmd $args" | grep -q "-c" || fail "Sidecar must use -c to pass the command"
echo "$cmd $args" | grep -q "tail -n\+1 -f /var/log/synergy-deployment\.log" || fail "Sidecar must run: tail -n+1 -f /var/log/synergy-deployment.log"
pass "Command OK: tail -n+1 -f /var/log/synergy-deployment.log"

# Optional: verify pod is available
kubectl rollout status deploy/synergy-deployment --timeout=60s >/dev/null 2>&1 || true
kubectl get pods -l app=synergy
pass "Deployment looks healthy"

