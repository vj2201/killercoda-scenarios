Congratulations! You've successfully configured a deployment with containerPort and exposed it using a NodePort Service.

**What you learned:**

1. **containerPort Configuration**
   - Declaring which port a container listens on
   - Adding port name and protocol metadata
   - Using `kubectl edit` to modify existing deployments

2. **NodePort Services**
   - Exposing pods on a static port (30000-32767) on each node
   - Port mapping: NodePort → Service Port → Target Port
   - Making services accessible from outside the cluster

3. **Service Selectors**
   - How Services use label selectors to find pods
   - Matching deployment pod labels with service selectors
   - Verifying endpoints to confirm proper routing

4. **Service Types Comparison**
   - **ClusterIP** (default): Internal cluster access only
   - **NodePort**: Exposes service on each node's IP at a static port
   - **LoadBalancer**: Creates external load balancer (cloud environments)

**Key Commands:**

- `kubectl edit deploy <name> -n <namespace>` - Edit deployment in-place
- `kubectl create service nodeport <name> --tcp=<port>:<targetPort> --node-port=<nodePort>` - Imperative NodePort creation
- `kubectl get svc -n <namespace>` - List services
- `kubectl describe svc <name> -n <namespace>` - View service details and endpoints
- `kubectl get nodes -o wide` - Get node IPs for testing

**Testing Services:**

```bash
# Get node IP
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

# Test via NodePort
curl http://$NODE_IP:30080
```

**Best Practices:**

- Always configure containerPort for clarity (even though optional)
- Use meaningful port names (http, https, metrics, etc.)
- Choose NodePort values in the valid range (30000-32767)
- Verify endpoints after creating services
- Use NodePort for development/testing; prefer LoadBalancer for production

**CKA Exam Tips:**

- Imperative commands are faster: `kubectl create service nodeport`
- Remember to add selectors manually when using imperative commands
- Use `--dry-run=client -o yaml` to generate base YAML quickly
- Verify with `kubectl get svc` and `kubectl describe svc`
- Check endpoints to ensure pods are being selected

Great job! You're now ready to expose Kubernetes applications externally using NodePort Services.
