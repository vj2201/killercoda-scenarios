# Solution: Ingress Lab

## Step 1: Verify existing deployment

```bash
# Check deployment
kubectl get deploy -n echo-sound

# Check pods
kubectl get pods -n echo-sound

# Verify ingress controller
kubectl get ingressclass
kubectl get pods -n ingress-nginx
```

Expected state:
- Deployment: `echo-deployment` (2 replicas)
- Pods listening on port 5678
- Nginx ingress controller ready

## Step 2: Create NodePort Service

**Option 1: Using kubectl expose (fastest for exam)**
```bash
kubectl expose deployment echo-deployment \
  --name=echo-service \
  --port=8080 \
  --target-port=5678 \
  --type=NodePort \
  -n echo-sound
```

**Option 2: Using YAML manifest**
```bash
kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Service
metadata:
  name: echo-service
  namespace: echo-sound
spec:
  type: NodePort
  selector:
    app: echo
  ports:
  - port: 8080
    targetPort: 5678
    protocol: TCP
YAML
```

Or use the solution file:
```bash
kubectl apply -f solution/echo-service.solution.yaml
```

### Verify Service

```bash
# Check service
kubectl get svc -n echo-sound

# Get NodePort
kubectl get svc echo-service -n echo-sound -o jsonpath='{.spec.ports[0].nodePort}{"\n"}'

# Test directly (optional)
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
NODE_PORT=$(kubectl get svc echo-service -n echo-sound -o jsonpath='{.spec.ports[0].nodePort}')
curl $NODE_IP:$NODE_PORT
```

## Step 3: Create Ingress Resource

**Option 1: Imperative (FASTEST for exam)**
```bash
kubectl create ingress echo \
  --namespace=echo-sound \
  --class=nginx \
  --rule="example.org/echo=echo-service:8080"
```

**Option 2: Declarative YAML**
```bash
kubectl apply -f - <<'YAML'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: echo
  namespace: echo-sound
spec:
  ingressClassName: nginx
  rules:
  - host: example.org
    http:
      paths:
      - path: /echo
        pathType: Prefix
        backend:
          service:
            name: echo-service
            port:
              number: 8080
YAML
```

Or use the solution file:
```bash
kubectl apply -f solution/echo-ingress.solution.yaml
```

### Verify Ingress

```bash
# Check ingress
kubectl get ingress -n echo-sound

# Detailed view
kubectl describe ingress echo -n echo-sound

# Check for ADDRESS (may take a minute)
kubectl get ingress echo -n echo-sound -o wide
```

## Step 4: Test with curl

### Get required values

```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
INGRESS_PORT=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')

echo "Node IP: $NODE_IP"
echo "Ingress Port: $INGRESS_PORT"
```

### Test with Host header

```bash
# Get response
curl -H "Host: example.org" http://$NODE_IP:$INGRESS_PORT/echo

# Get HTTP status code (exam-style)
curl -o /dev/null -s -w "%{http_code}\n" -H "Host: example.org" http://$NODE_IP:$INGRESS_PORT/echo
```

Expected: `200` and echo response from pod

### Optional: Using /etc/hosts

```bash
# Add to /etc/hosts
echo "$NODE_IP example.org" | sudo tee -a /etc/hosts

# Test directly
curl http://example.org:$INGRESS_PORT/echo
```

## Complete All-in-One Solution

**Fastest approach (imperative commands):**
```bash
# 1. Create Service
kubectl expose deployment echo-deployment \
  --name=echo-service \
  --port=8080 \
  --target-port=5678 \
  --type=NodePort \
  -n echo-sound

# 2. Create Ingress (imperative - fastest!)
kubectl create ingress echo \
  --namespace=echo-sound \
  --class=nginx \
  --rule="example.org/echo=echo-service:8080"

# 3. Test
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
INGRESS_PORT=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
curl -H "Host: example.org" http://$NODE_IP:$INGRESS_PORT/echo
```

## Troubleshooting

### Service not working

```bash
# Check endpoints
kubectl get endpoints echo-service -n echo-sound

# Should show pod IPs on port 5678
# If empty, check selector matches pod labels
kubectl get pods -n echo-sound --show-labels
```

### Ingress not working

```bash
# Check ingress events
kubectl describe ingress echo -n echo-sound

# Check ingress controller logs
kubectl logs -n ingress-nginx -l app.kubernetes.io/component=controller

# Verify IngressClass
kubectl get ingressclass
```

### curl returns 404

- Check path in Ingress matches request (/echo)
- Verify Host header matches Ingress rules (example.org)
- Ensure pathType is Prefix, not Exact

### curl returns 503

- Service may not have endpoints
- Pods may not be ready
- Check: `kubectl get endpoints -n echo-sound`

## Key Points for CKA Exam

1. **kubectl expose is fastest** for creating Services
2. **Know the port mapping**: client → Service port → targetPort (container)
3. **IngressClassName is required** in newer Kubernetes versions
4. **pathType matters**: Prefix vs Exact
5. **Host header testing**: Use `-H "Host: ..."` with curl
6. **Exam may provide exact curl command** to verify - run it exactly as shown
