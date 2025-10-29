Create a NodePort Service named `nodeport-service` exposing port 80 on NodePort 30080.

**Option 1: Imperative command (with YAML for nodePort)**

```bash
kubectl create service nodeport nodeport-service \
  --tcp=80:80 \
  --node-port=30080 \
  -n relative \
  --dry-run=client -o yaml > nodeport-service.yaml
```

Edit the generated file to add the selector:

`kubectl edit -f nodeport-service.yaml` or use vi/nano

Add selector to match deployment pods:
```yaml
spec:
  selector:
    app: nodeport-app
```

Then apply:

`kubectl apply -f nodeport-service.yaml -n relative`

**Option 2: Complete YAML (recommended)**

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

**Verify the Service:**

`kubectl get svc -n relative`

You should see `nodeport-service` with TYPE `NodePort` and PORT(S) `80:30080/TCP`.

Check Service details:

`kubectl describe svc nodeport-service -n relative`

Verify:
- Type: NodePort
- Port: 80
- TargetPort: 80
- NodePort: 30080
- Endpoints: Should show 2 pod IPs (from the 2 replicas)

**Test the Service:**

Get node IP:

`kubectl get nodes -o wide`

Test using NodePort:

```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
curl http://$NODE_IP:30080
```

You should see the nginx welcome page!

**Success criteria:**
- ✅ Service `nodeport-service` exists in `relative` namespace
- ✅ Type: NodePort
- ✅ Exposes port 80
- ✅ NodePort: 30080
- ✅ Selector matches deployment pods (`app: nodeport-app`)
- ✅ Service has endpoints (pod IPs)
- ✅ Accessible via NodeIP:30080

You've successfully exposed the deployment using a NodePort Service!
