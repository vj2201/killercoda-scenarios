Create a NodePort Service named `echo-service` to expose the deployment on port 8080.

The deployment's containers listen on port 5678, but you need to expose them via a Service on port 8080.

Create the Service:

```bash
kubectl expose deployment echo-deployment \
  --name=echo-service \
  --port=8080 \
  --target-port=5678 \
  --type=NodePort \
  -n echo-sound
```

**Understanding the flags:**
- `--name=echo-service`: Name of the Service
- `--port=8080`: Port the Service listens on (what clients connect to)
- `--target-port=5678`: Port the container is listening on
- `--type=NodePort`: Exposes the Service on a port on each node

Alternatively, create using a YAML manifest:

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

Verify the Service was created:

`kubectl get svc -n echo-sound`

Get the NodePort assigned:

`kubectl get svc echo-service -n echo-sound -o jsonpath='{.spec.ports[0].nodePort}{"\n"}'`

Note this NodePort number - you'll use it for testing.

Test the Service directly (optional):

```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
NODE_PORT=$(kubectl get svc echo-service -n echo-sound -o jsonpath='{.spec.ports[0].nodePort}')
echo "Testing: http://$NODE_IP:$NODE_PORT"
curl $NODE_IP:$NODE_PORT
```

You should see the echo response from the pod.

**Success criteria:**
- Service `echo-service` exists in `echo-sound` namespace
- Type: NodePort
- Service Port: 8080
- TargetPort: 5678
- Selector matches deployment pods (app=echo)
