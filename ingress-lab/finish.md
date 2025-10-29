Great job configuring Kubernetes Ingress!

You successfully:
- Verified the existing `echo-deployment` in the `echo-sound` namespace
- Created a NodePort Service named `echo-service` exposing port 8080 → 5678
- Created an Ingress resource named `echo` routing http://example.org/echo to the service
- Tested the Ingress using curl with Host headers

**Key takeaways:**

**Service Exposure:**
- Services provide stable networking for pods
- NodePort exposes services on node IPs (port range: 30000-32767)
- Service port vs target port: clients → Service:8080 → Pods:5678

**Ingress Concepts:**
- Ingress resources define HTTP/HTTPS routing rules
- IngressClass specifies which controller handles the Ingress
- Host-based routing uses HTTP Host header
- Path-based routing uses URL paths (/echo, /api, etc.)
- Ingress controllers (nginx, traefik, etc.) implement the routing

**The request flow:**
```
Client Request (Host: example.org)
        ↓
http://NODE_IP:INGRESS_PORT/echo
        ↓
Ingress Controller (nginx)
        ↓
Matches Ingress rules (host + path)
        ↓
Routes to echo-service:8080
        ↓
Service selects pod
        ↓
Pod responds on port 5678
```

**Common Ingress patterns:**

1. **Path-based routing:**
```yaml
paths:
- path: /api
  backend: api-service
- path: /web
  backend: web-service
```

2. **Multiple hosts:**
```yaml
rules:
- host: api.example.com
  backend: api-service
- host: www.example.com
  backend: web-service
```

3. **TLS/HTTPS:**
```yaml
spec:
  tls:
  - hosts:
    - example.org
    secretName: tls-secret
```

**Next steps to explore:**
- Configure Ingress with TLS certificates
- Set up path rewrites and redirects using annotations
- Implement multiple backend services with different paths
- Practice with different Ingress controllers (Traefik, HAProxy, etc.)
- Use Ingress with cert-manager for automatic TLS certificates
- Configure Ingress authentication and authorization
- Test Ingress with different pathTypes (Exact, Prefix, ImplementationSpecific)

**CKA exam tips:**
- Know how to create Services imperatively with `kubectl expose`
- Understand Service types: ClusterIP, NodePort, LoadBalancer
- Be comfortable creating Ingress resources from scratch
- Practice curl commands with -H for Host headers
- Remember pathType: Prefix vs Exact
- Know how to troubleshoot: check Service endpoints, Ingress events, controller logs
