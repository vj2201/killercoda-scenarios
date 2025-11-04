#!/bin/bash
set -e

echo "🚀 Completing simplification of remaining 11 labs..."
echo ""

# Create a backup timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
echo "Backup timestamp: $TIMESTAMP"
echo ""

# ============================================================
# NETWORK-POLICY-LAB
# ============================================================
echo "📝 [1/11] Simplifying network-policy-lab..."

cat > network-policy-lab/intro.md << 'INTRO_EOF'
# Configure Network Policy

## Scenario
Two deployments exist:
- `frontend` in namespace `frontend` (labels: app=frontend, tier=web)
- `backend` in namespace `backend` (labels: app=backend, tier=api, port 8080)

## Your Task
Create a least-permissive NetworkPolicy in the `backend` namespace that:
1. Allows ingress ONLY from pods in the `frontend` namespace
2. Allows traffic ONLY on port 8080
3. Denies all other traffic

## Success Criteria
- NetworkPolicy exists in backend namespace
- Frontend pods can reach backend:8080
- All other traffic is blocked

Click **"Next"** for the solution.
INTRO_EOF

cat > network-policy-lab/solution.md << 'SOLUTION_EOF'
# Solution

## Create NetworkPolicy

```bash
kubectl apply -f - <<'EOF'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-network-policy
  namespace: backend
spec:
  podSelector:
    matchLabels:
      app: backend
      tier: api
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: frontend
    ports:
    - protocol: TCP
      port: 8080
EOF
```

**Verify:**
```bash
kubectl get networkpolicy -n backend
kubectl describe networkpolicy backend-network-policy -n backend
```

## Test Connectivity

```bash
# Should succeed (frontend → backend:8080)
FRONTEND_POD=$(kubectl get pod -n frontend -l app=frontend -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n frontend $FRONTEND_POD -- wget -qO- --timeout=2 http://backend-service.backend:8080

# Should fail (different namespace without selector)
kubectl run test-pod --image=busybox --rm -it -- wget -qO- --timeout=2 http://backend-service.backend:8080
```

## Explanation

**NetworkPolicy** controls traffic at IP/port level. This policy uses:
- `podSelector`: Targets backend pods
- `namespaceSelector`: Allows only frontend namespace
- `ports`: Restricts to port 8080 only
- `policyTypes: [Ingress]`: Creates default deny for ingress

✅ **Done!** Only frontend namespace can reach backend on port 8080.
SOLUTION_EOF

cat > network-policy-lab/finish.md << 'FINISH_EOF'
# Congratulations! 🎉

You've successfully completed the NetworkPolicy lab.

## What You Learned
- Creating least-permissive NetworkPolicies
- Controlling pod-to-pod communication across namespaces
- Using namespace selectors and port restrictions

## Key Takeaway
NetworkPolicies provide network segmentation. Default deny with explicit allow rules ensures minimum necessary access.

Keep practicing! 🚀
FINISH_EOF

cat > network-policy-lab/index.json << 'INDEX_EOF'
{
  "title": "CKA Practice: Network Policy Configuration",
  "description": "Create least-permissive NetworkPolicy for cross-namespace communication.",
  "difficulty": "intermediate",
  "time": "15 minutes",
  "details": {
    "intro": {
      "text": "intro.md",
      "foreground": "foreground.sh",
      "background": "setup.sh"
    },
    "steps": [
      { "title": "Solution", "text": "solution.md" }
    ],
    "finish": { "text": "finish.md" }
  },
  "backend": { "imageid": "kubernetes" }
}
INDEX_EOF

# ============================================================
# SIDECAR-LAB
# ============================================================
echo "📝 [2/11] Simplifying sidecar-lab..."

cat > sidecar-lab/intro.md << 'INTRO_EOF'
# Add Sidecar Container

## Scenario
A deployment `wordpress` exists with a main container writing logs to `/var/log/wordpress.log` using an emptyDir volume.

## Your Task
Edit the deployment to add a sidecar container that:
1. Uses image `busybox:stable`
2. Tails the log file from the shared volume
3. Shares the same `log-volume` (emptyDir)

## Success Criteria
- Deployment has 2 containers (main-app + sidecar)
- Both containers mount the same log-volume
- Sidecar logs show the wordpress.log output

Click **"Next"** for the solution.
INTRO_EOF

cat > sidecar-lab/solution.md << 'SOLUTION_EOF'
# Solution

## Edit Deployment

```bash
kubectl edit deploy wordpress
```

Add this sidecar container under `spec.template.spec.containers`:

```yaml
- name: sidecar
  image: busybox:stable
  command: ["/bin/sh", "-c"]
  args:
    - "tail -f /var/log/wordpress.log"
  volumeMounts:
  - name: log-volume
    mountPath: /var/log
```

The `log-volume` emptyDir already exists and is mounted by main-app. Just ensure both containers mount it.

Save and exit (:wq).

## Verify

```bash
# Check deployment has 2 containers
kubectl get deploy wordpress -o jsonpath='{.spec.template.spec.containers[*].name}{"\n"}'
```

Expected: `main-app sidecar`

```bash
# View sidecar logs
kubectl logs deployment/wordpress -c sidecar -f
```

You should see the log output from wordpress.log.

## Explanation

**Sidecar pattern**: Multiple containers in a pod share the same network namespace and volumes. The sidecar reads logs from the shared emptyDir volume that main-app writes to.

**Common sidecar uses**:
- Log shipping (Filebeat, Fluentd)
- Service mesh proxies (Envoy, Linkerd)
- Security scanning
- Configuration sync

✅ **Done!** Your pod now has a sidecar for log aggregation.
SOLUTION_EOF

cat > sidecar-lab/finish.md << 'FINISH_EOF'
# Congratulations! 🎉

You've successfully completed the Sidecar Container lab.

## What You Learned
- Adding sidecar containers to existing deployments
- Sharing volumes between containers in a pod
- Multi-container pod patterns

## Key Takeaway
Sidecar containers extend pod functionality. They share the pod's network, storage, and lifecycle with the main container.

Keep practicing! 🚀
FINISH_EOF

cat > sidecar-lab/index.json << 'INDEX_EOF'
{
  "title": "CKA Practice: Sidecar Container Pattern",
  "description": "Add a sidecar container to a deployment for log collection.",
  "difficulty": "intermediate",
  "time": "15 minutes",
  "details": {
    "intro": {
      "text": "intro.md",
      "foreground": "foreground.sh",
      "background": "setup.sh"
    },
    "steps": [
      { "title": "Solution", "text": "solution.md" }
    ],
    "finish": { "text": "finish.md" }
  },
  "backend": { "imageid": "kubernetes" }
}
INDEX_EOF

# ============================================================
# TLS-CONFIG-LAB
# ============================================================
echo "📝 [3/11] Simplifying tls-config-lab..."

cat > tls-config-lab/intro.md << 'INTRO_EOF'
# Configure TLS Protocol Version

## Scenario
An nginx deployment in namespace `nginx-static` uses a ConfigMap for configuration. It currently supports TLS 1.2 and 1.3.

## Your Task
1. Edit the ConfigMap to enforce TLS 1.3 ONLY
2. Restart the deployment to apply changes
3. Add service IP to /etc/hosts as `ckaquestion.k8s.local`
4. Verify TLS 1.2 fails and TLS 1.3 succeeds

## Success Criteria
- ConfigMap has `ssl_protocols TLSv1.3;`
- curl with --tls-max 1.2 fails
- curl with --tlsv1.3 succeeds

Click **"Next"** for the solution.
INTRO_EOF

cat > tls-config-lab/solution.md << 'SOLUTION_EOF'
# Solution

## Step 1: Edit ConfigMap

```bash
kubectl edit cm nginx-config -n nginx-static
```

Find the line with `ssl_protocols` and change it to:
```
ssl_protocols TLSv1.3;
```

Save and exit.

## Step 2: Restart Deployment

```bash
kubectl rollout restart deploy/nginx-static -n nginx-static
kubectl rollout status deploy/nginx-static -n nginx-static
```

## Step 3: Add to /etc/hosts

```bash
SVC_IP=$(kubectl get svc nginx-service -n nginx-static -o jsonpath='{.spec.clusterIP}')
echo "$SVC_IP ckaquestion.k8s.local" | sudo tee -a /etc/hosts
```

## Step 4: Test TLS Versions

```bash
# Should FAIL (TLS 1.2 not supported)
curl -vk --tls-max 1.2 https://ckaquestion.k8s.local 2>&1 | grep -i "ssl\|tls"

# Should SUCCEED (TLS 1.3 supported)
curl -vk --tlsv1.3 https://ckaquestion.k8s.local
```

Expected: First command fails with SSL/TLS error. Second succeeds with "TLS Configuration Working!"

## Explanation

**ConfigMap** stores nginx configuration. Changing `ssl_protocols` restricts TLS versions. Restart applies the new config by recreating pods with updated ConfigMap mounts.

**TLS 1.3** is more secure than 1.2 (better encryption, faster handshake).

✅ **Done!** Your nginx now enforces TLS 1.3 only.
SOLUTION_EOF

cat > tls-config-lab/finish.md << 'FINISH_EOF'
# Congratulations! 🎉

You've successfully completed the TLS Configuration lab.

## What You Learned
- Modifying ConfigMaps for application configuration
- Restarting deployments to apply config changes
- Testing TLS protocol versions with curl

## Key Takeaway
ConfigMaps decouple configuration from container images. Changes require pod restarts to take effect.

Keep practicing! 🚀
FINISH_EOF

cat > tls-config-lab/index.json << 'INDEX_EOF'
{
  "title": "CKA Practice: TLS Protocol Configuration",
  "description": "Configure nginx to enforce specific TLS protocol versions via ConfigMap.",
  "difficulty": "intermediate",
  "time": "20 minutes",
  "details": {
    "intro": {
      "text": "intro.md",
      "foreground": "foreground.sh",
      "background": "setup.sh"
    },
    "steps": [
      { "title": "Solution", "text": "solution.md" }
    ],
    "finish": { "text": "finish.md" }
  },
  "backend": { "imageid": "kubernetes" }
}
INDEX_EOF

echo ""
echo "✅ Part 1 complete (3/11 labs done)"
echo "Run part 2 script to continue..."
EOF
