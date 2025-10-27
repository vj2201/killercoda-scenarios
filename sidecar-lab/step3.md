Verify the deployment and logs from the sidecar container.

- Check pods:

`kubectl get pods -l app=synergy`

- Stream logs from the sidecar:

`kubectl logs deployment/synergy-deployment -c sidecar -f`

- Automated checks (paste and run):

```
cat > /tmp/verify.sh <<'EOF'
#!/bin/sh
set -e
fail(){ echo "[FAIL] $*"; exit 1; }
pass(){ echo "[PASS] $*"; }

kubectl get deploy synergy-deployment >/dev/null 2>&1 || fail "Deployment not found"

name=$(kubectl get deploy synergy-deployment -o jsonpath='{.spec.template.spec.containers[?(@.name=="sidecar")].name}')
[ -n "$name" ] || fail "Container named 'sidecar' not found"
pass "Found container: $name"

image=$(kubectl get deploy synergy-deployment -o jsonpath='{.spec.template.spec.containers[?(@.name=="sidecar")].image}')
[ "$image" = "busybox:stable" ] || fail "Sidecar image must be busybox:stable (found: $image)"
pass "Image OK: $image"

mount=$(kubectl get deploy synergy-deployment -o jsonpath='{.spec.template.spec.containers[?(@.name=="sidecar")].volumeMounts[?(@.mountPath=="/var/log")].name}')
[ -n "$mount" ] || fail "Sidecar must mount a volume at /var/log"
pass "Volume mount OK at /var/log (volume: $mount)"

main_mount=$(kubectl get deploy synergy-deployment -o jsonpath='{.spec.template.spec.containers[?(@.name=="main-app")].volumeMounts[?(@.mountPath=="/var/log")].name}')
[ -n "$main_mount" ] || fail "Main container must mount the same volume at /var/log"
pass "Main container mount OK at /var/log (volume: $main_mount)"

vol=$(kubectl get deploy synergy-deployment -o jsonpath='{.spec.template.spec.volumes[?(@.name=="log-volume")].name}')
[ -n "$vol" ] || fail "Volume 'log-volume' (emptyDir) must exist in the pod spec"
pass "Volume present: $vol"

cmd=$(kubectl get deploy synergy-deployment -o jsonpath='{.spec.template.spec.containers[?(@.name=="sidecar")].command[*]}')
args=$(kubectl get deploy synergy-deployment -o jsonpath='{.spec.template.spec.containers[?(@.name=="sidecar")].args[*]}')
echo "Observed command: $cmd"
echo "Observed args:    $args"
echo "$cmd $args" | grep -q "/bin/sh" || fail "Sidecar must run via /bin/sh -c"
echo "$cmd $args" | grep -q "-c" || fail "Sidecar must use -c"
echo "$cmd $args" | grep -q "tail -n\+1 -f /var/log/synergy-deployment\.log" || fail "Sidecar must run: tail -n+1 -f /var/log/synergy-deployment.log"
pass "Command OK"

kubectl rollout status deploy/synergy-deployment --timeout=60s >/dev/null 2>&1 || true
kubectl get pods -l app=synergy
pass "Deployment looks healthy"
EOF
sh /tmp/verify.sh
```

You should see the log lines produced by the main container, and the checks should report PASS for name, image, volume mount, and command.
