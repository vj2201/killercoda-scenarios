# NodePort Service Configuration - Complete Solution

This guide provides the complete solution for the NodePort Service Configuration lab.

## Task Summary

1. Configure the deployment `nodeport-deployment` in namespace `relative` to expose port 80 (name=http, protocol=TCP)
2. Create a NodePort Service named `nodeport-service` exposing port 80 on NodePort 30080
3. Verify the service routes traffic to the pods correctly

---

## Step 1: Configure Deployment containerPort

### Verify Current State

```bash
kubectl get deploy -n relative
kubectl get deploy nodeport-deployment -n relative -o yaml | grep -A10 "containers:"
```

You'll notice no `containerPort` is defined.

### Solution: Add containerPort

**Option 1: Using kubectl edit (Interactive)**

```bash
kubectl edit deploy nodeport-deployment -n relative
```

Add the `ports` section under the nginx container:

```yaml
spec:
  template:
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
        ports:
        - containerPort: 80
          name: http
          protocol: TCP
```

Save and exit. The deployment will automatically roll out.

**Option 2: Using kubectl patch (One-liner)**

```bash
kubectl patch deploy nodeport-deployment -n relative --type='json' -p='[
  {
    "op": "add",
    "path": "/spec/template/spec/containers/0/ports",
    "value": [
      {
        "containerPort": 80,
        "name": "http",
        "protocol": "TCP"
      }
    ]
  }
]'
```

**Option 3: Apply complete YAML**

Apply the provided solution file:

```bash
kubectl apply -f solution/nodeport-deployment-with-port.yaml
```

### Verify the Configuration

Wait for rollout to complete:

```bash
kubectl rollout status deploy/nodeport-deployment -n relative
```

Verify containerPort is configured:

```bash
kubectl get deploy nodeport-deployment -n relative -o yaml | grep -A5 "ports:"
```

Expected output:
```yaml
ports:
- containerPort: 80
  name: http
  protocol: TCP
```

Check pods are running:

```bash
kubectl get pods -n relative -l app=nodeport-app
```

---

## Step 2: Create NodePort Service

### Solution: Create NodePort Service

**Option 1: Imperative Command (Fastest for Exam)**

Generate base YAML:

```bash
kubectl create service nodeport nodeport-service \
  --tcp=80:80 \
  --node-port=30080 \
  -n relative \
  --dry-run=client -o yaml > nodeport-service.yaml
```

Edit the file to add the selector:

```bash
kubectl edit -f nodeport-service.yaml
```

or use vi/nano:

```bash
vi nodeport-service.yaml
```

Add selector to match deployment pods:

```yaml
spec:
  selector:
    app: nodeport-app
```

Then apply:

```bash
kubectl apply -f nodeport-service.yaml -n relative
```

**Option 2: Complete YAML (Recommended)**

Create the service directly:

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

**Option 3: Apply Solution File**

```bash
kubectl apply -f solution/nodeport-service.yaml
```

### Verify the Service

List services:

```bash
kubectl get svc -n relative
```

Expected output:
```
NAME               TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
nodeport-service   NodePort   10.96.xxx.xxx   <none>        80:30080/TCP   10s
```

Check service details:

```bash
kubectl describe svc nodeport-service -n relative
```

Verify the following:
- **Type:** NodePort
- **Port:** 80/TCP
- **TargetPort:** 80/TCP
- **NodePort:** 30080/TCP
- **Endpoints:** Should show 2 pod IPs (from 2 replicas)

Example output:
```
Name:                     nodeport-service
Namespace:                relative
Type:                     NodePort
Port:                     http  80/TCP
TargetPort:               80/TCP
NodePort:                 http  30080/TCP
Endpoints:                10.244.0.5:80,10.244.0.6:80
```

If Endpoints is empty, check:
- Selector matches pod labels: `kubectl get pods -n relative --show-labels`
- Pods are running: `kubectl get pods -n relative`

---

## Step 3: Test the Service

### Get Node IP

```bash
kubectl get nodes -o wide
```

Or extract just the IP:

```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
echo $NODE_IP
```

### Test Access via NodePort

```bash
curl http://$NODE_IP:30080
```

Expected output: nginx welcome page HTML

```html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
...
```

### Alternative: Test from within the cluster

```bash
kubectl run test-pod --image=curlimages/curl:latest --rm -it --restart=Never -- \
  curl http://nodeport-service.relative.svc.cluster.local:80
```

---

## Verification Checklist

- ✅ Deployment `nodeport-deployment` exists in `relative` namespace
- ✅ Deployment has containerPort 80 configured with name=http, protocol=TCP
- ✅ Deployment has 2 running replicas
- ✅ Service `nodeport-service` exists in `relative` namespace
- ✅ Service type is NodePort
- ✅ Service exposes port 80
- ✅ Service has NodePort 30080
- ✅ Service selector matches deployment pods (`app: nodeport-app`)
- ✅ Service has 2 endpoints (pod IPs)
- ✅ Service is accessible via NodeIP:30080
- ✅ curl returns nginx welcome page

---

## Key Points

**containerPort Configuration:**
- While containerPort is technically optional (pod still listens on port), it's a best practice
- Provides documentation and enables other features (like service discovery)
- Makes port configuration explicit and clear

**NodePort Service:**
- Exposes service on ALL nodes at the same port
- NodePort must be in range 30000-32767 (default)
- Can specify nodePort explicitly or let Kubernetes assign one
- Each node proxies the port to the service

**Port Mapping Flow:**
```
External Request → NodeIP:30080 (NodePort)
                 ↓
              Service:80 (Service Port)
                 ↓
              Pod:80 (TargetPort/containerPort)
```

**Selector Matching:**
- Service selector must match pod labels exactly
- Labels are defined in deployment's `template.metadata.labels`
- Check with: `kubectl get pods -n relative --show-labels`

---

## Common Mistakes to Avoid

1. **Forgetting to add selector** - Imperative command doesn't include selector
2. **Wrong namespace** - Service and pods must be in same namespace
3. **Label mismatch** - Selector labels must match pod labels exactly
4. **NodePort out of range** - Must be 30000-32767
5. **Not waiting for rollout** - Changes to deployment take time to apply
6. **Testing wrong port** - Use NodePort (30080), not service port (80)

---

## Time-Saving Tips for CKA Exam

1. **Use imperative commands** for speed, then edit to add selectors
2. **Copy from kubectl explain** for correct YAML structure
   ```bash
   kubectl explain service.spec.ports
   ```
3. **Use --dry-run=client -o yaml** to generate base manifests
4. **Verify immediately** after each step - don't wait until the end
5. **Check endpoints** to debug routing issues quickly

---

## Additional Commands

**View service in different formats:**
```bash
# Wide output
kubectl get svc -n relative -o wide

# YAML output
kubectl get svc nodeport-service -n relative -o yaml

# JSON with specific fields
kubectl get svc nodeport-service -n relative -o jsonpath='{.spec.ports[0].nodePort}'
```

**Monitor deployment rollout:**
```bash
# Watch rollout status
kubectl rollout status deploy/nodeport-deployment -n relative

# View rollout history
kubectl rollout history deploy/nodeport-deployment -n relative

# Undo if needed
kubectl rollout undo deploy/nodeport-deployment -n relative
```

**Debug connectivity:**
```bash
# Check pod logs
kubectl logs -n relative -l app=nodeport-app

# Exec into pod
kubectl exec -it -n relative <pod-name> -- /bin/bash

# Port forward for testing
kubectl port-forward -n relative svc/nodeport-service 8080:80
curl http://localhost:8080
```

---

## Success Criteria Met

If you can run these commands successfully, you've completed the lab:

```bash
# All checks pass
kubectl get deploy nodeport-deployment -n relative -o yaml | grep -q "containerPort: 80"
kubectl get svc nodeport-service -n relative -o yaml | grep -q "nodePort: 30080"
kubectl get endpoints nodeport-service -n relative | grep -q "10.244"
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
curl -s http://$NODE_IP:30080 | grep -q "Welcome to nginx"
```

All commands should return successfully without errors.

---

**Congratulations!** You've successfully completed the NodePort Service Configuration lab.
