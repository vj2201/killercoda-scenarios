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
