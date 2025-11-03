#!/bin/bash
set -e

echo "🚀 Simplifying all Kubernetes labs..."
echo "This will create intro.md, solution.md, finish.md and update index.json for each lab"
echo ""

# ============================================================
# NODEPORT-LAB
# ============================================================
echo "📝 Simplifying nodeport-lab..."

cat > nodeport-lab/intro.md << 'EOF'
# Configure NodePort Service

## Scenario
A deployment `nodeport-deployment` exists in namespace `relative` with nginx:1.24 but has NO `containerPort` defined.

## Your Task
1. Edit the deployment to add `containerPort: 80` with name `http`
2. Create a NodePort Service named `nodeport-service` exposing port 30080

## Success Criteria
- Deployment has containerPort 80 configured
- Service exists with NodePort 30080
- Can curl http://NODE_IP:30080 successfully

Click **"Next"** for the solution.
EOF

cat > nodeport-lab/solution.md << 'EOF'
# Solution

## Step 1: Edit Deployment to Add containerPort

```bash
kubectl edit deploy nodeport-deployment -n relative
```

Add this under `spec.template.spec.containers`:
```yaml
ports:
- containerPort: 80
  name: http
  protocol: TCP
```

Save and exit (:wq in vim).

## Step 2: Create NodePort Service

```bash
kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Service
metadata:
  name: nodeport-service
  namespace: relative
spec:
  type: NodePort
  selector:
    app: nodeport-app
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
    protocol: TCP
    name: http
YAML
```

**Verify:**
```bash
kubectl get svc nodeport-service -n relative
```

## Step 3: Test Connectivity

```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
curl http://$NODE_IP:30080
```

**Expected:** You should see the nginx welcome page.

## Explanation

**containerPort**: Declares which port the container listens on (documentation only, not enforced).

**NodePort**: Exposes the Service on each Node's IP at a static port (range: 30000-32767). Traffic to NODE_IP:30080 → Service → Pod:80.

✅ **Done!** Your deployment is now accessible on port 30080 on any cluster node.
EOF

cat > nodeport-lab/finish.md << 'EOF'
# Congratulations! 🎉

You've successfully completed the NodePort Service lab.

## What You Learned
- Configuring containerPort in pod specifications
- Creating NodePort Services for external access
- Testing Service connectivity

## Key Takeaway
NodePort Services expose pods on a specific port (30000-32767) on all nodes, making them accessible from outside the cluster.

Keep practicing! 🚀
EOF

# Update index.json
cat > nodeport-lab/index.json << 'EOF'
{
  "title": "CKA Practice: NodePort Service Configuration",
  "description": "Configure containerPort and expose a deployment via NodePort Service.",
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
EOF

# ============================================================
# HPA-LAB
# ============================================================
echo "📝 Simplifying hpa-lab..."

cat > hpa-lab/intro.md << 'EOF'
# Configure HorizontalPodAutoscaler

## Scenario
A deployment `apache-deployment` exists in namespace `autoscale` with CPU resource requests configured. The metrics-server is installed.

## Your Task
1. Create an HPA named `apache-server` targeting 50% CPU utilization
2. Configure min replicas: 1, max replicas: 4
3. Set downscale stabilization window to 30 seconds

## Success Criteria
- HPA exists targeting apache-deployment
- CPU target is 50%
- Min/max replicas are 1/4
- Downscale stabilization window is 30 seconds

Click **"Next"** for the solution.
EOF

cat > hpa-lab/solution.md << 'EOF'
# Solution

## Step 1: Create Basic HPA

```bash
kubectl autoscale deployment apache-deployment \
  --name=apache-server \
  --cpu-percent=50 \
  --min=1 \
  --max=4 \
  -n autoscale
```

**Verify:**
```bash
kubectl get hpa apache-server -n autoscale
```

## Step 2: Add Behavior Policy (Downscale Stabilization)

```bash
kubectl edit hpa apache-server -n autoscale
```

Add this under `spec`:
```yaml
behavior:
  scaleDown:
    stabilizationWindowSeconds: 30
```

Save and exit.

## Step 3: Verify Configuration

```bash
kubectl get hpa apache-server -n autoscale -o yaml
```

Check that you see:
- `targetCPUUtilizationPercentage: 50`
- `minReplicas: 1`
- `maxReplicas: 4`
- `behavior.scaleDown.stabilizationWindowSeconds: 30`

**Verify stabilization window:**
```bash
kubectl get hpa apache-server -n autoscale \
  -o jsonpath='{.spec.behavior.scaleDown.stabilizationWindowSeconds}{"\n"}'
```

Expected output: `30`

## Explanation

**HPA** automatically scales pods based on CPU/memory metrics. The 50% target means: if average CPU > 50%, scale up; if < 50%, scale down.

**Stabilization window** prevents flapping by delaying scale-down decisions for 30 seconds after a scale-down recommendation.

✅ **Done!** Your deployment will auto-scale between 1-4 replicas based on CPU load.
EOF

cat > hpa-lab/finish.md << 'EOF'
# Congratulations! 🎉

You've successfully completed the HPA lab.

## What You Learned
- Creating Horizontal Pod Autoscalers
- Configuring CPU-based autoscaling thresholds
- Setting custom scaling behavior policies

## Key Takeaway
HPA automatically adjusts pod replicas based on resource metrics. Stabilization windows prevent rapid scaling oscillations.

Keep practicing! 🚀
EOF

cat > hpa-lab/index.json << 'EOF'
{
  "title": "CKA Practice: Horizontal Pod Autoscaler",
  "description": "Configure HPA with CPU targets and custom scaling behavior.",
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
EOF

echo ""
echo "✅ Script created successfully!"
echo ""
echo "To continue with remaining 11 labs, run:"
echo "  bash simplify_all_labs_part2.sh"
EOF
