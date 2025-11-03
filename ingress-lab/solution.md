# Solution

## Step 1: Verify Deployment

```bash
kubectl get deployment echo-deployment -n echo-sound
kubectl get pods -n echo-sound
```

## Step 2: Create NodePort Service

```bash
kubectl expose deployment echo-deployment \
  --name=echo-service \
  --port=8080 \
  --target-port=5678 \
  --type=NodePort \
  -n echo-sound
```

**Verify:**
```bash
kubectl get svc echo-service -n echo-sound
```

## Step 3: Create Ingress Resource

```bash
kubectl create ingress echo \
  --namespace=echo-sound \
  --class=nginx \
  --rule="example.org/echo=echo-service:8080"
```

**Verify:**
```bash
kubectl get ingress echo -n echo-sound
kubectl describe ingress echo -n echo-sound
```

## Step 4: Test with curl

```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
INGRESS_PORT=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')

curl -H "Host: example.org" http://$NODE_IP:$INGRESS_PORT/echo
```

**Expected:** You should see the echo response from the pod.

## Explanation

**Service** provides a stable endpoint for pods. **Ingress** routes HTTP traffic based on hostname and path. The nginx ingress controller reads Ingress resources and configures routing rules.

✅ **Done!** Traffic flows: Client → Ingress → Service → Pod
