Test the Ingress using curl to verify everything is working.

First, get the Ingress controller's NodePort:

```bash
INGRESS_PORT=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
echo "Ingress HTTP Port: $INGRESS_PORT"
```

Get the node IP:

```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
echo "Node IP: $NODE_IP"
```

Test the Ingress with the Host header:

```bash
curl -H "Host: example.org" http://$NODE_IP:$INGRESS_PORT/echo
```

You should see the echo response from the pod!

**For a more exam-style verification:**

```bash
curl -o /dev/null -s -w "%{http_code}\n" -H "Host: example.org" http://$NODE_IP:$INGRESS_PORT/echo
```

Expected output: `200` (HTTP OK)

**Alternative: Using /etc/hosts (more realistic):**

Add an entry to /etc/hosts:

```bash
echo "$NODE_IP example.org" | sudo tee -a /etc/hosts
```

Now you can curl directly:

```bash
curl http://example.org:$INGRESS_PORT/echo
```

**Testing without the path:**

```bash
# This should return 404 since we only configured /echo path
curl -H "Host: example.org" http://$NODE_IP:$INGRESS_PORT/
```

**All-in-one test script:**

```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
INGRESS_PORT=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')

echo "Testing http://example.org:$INGRESS_PORT/echo"
echo "---"
curl -H "Host: example.org" http://$NODE_IP:$INGRESS_PORT/echo
echo ""
echo "---"
echo "HTTP Status Code:"
curl -o /dev/null -s -w "%{http_code}\n" -H "Host: example.org" http://$NODE_IP:$INGRESS_PORT/echo
```

**Success criteria:**
- ✅ Service `echo-service` responds on NodePort
- ✅ Ingress `echo` exists in `echo-sound` namespace
- ✅ curl to http://example.org/echo returns 200 OK
- ✅ Response contains echo text from pods

**In a real CKA exam:**
- You might be given a specific curl command to run
- The ingress controller is usually pre-installed
- You need to know Service → Ingress → Controller flow
- Host headers and /etc/hosts manipulation are common
