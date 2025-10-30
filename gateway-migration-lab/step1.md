## Task: Migrate Ingress to Gateway API

### Step 1: Examine the Existing Ingress

View the existing Ingress resource:

```bash
kubectl get ingress web -n web-app -o yaml
```

Note the key configurations:
- **Host**: `gateway.web.k8s.local`
- **TLS**: Secret `web-tls-secret`
- **Path**: `/` → Service `web-service` port `80`

<details>
<summary>💡 Hint: Gateway API Concepts</summary>

**Gateway API** is the successor to Ingress, providing:
- More expressive routing
- Role-oriented design
- Portable across implementations

**Key Resources:**
- **GatewayClass**: Defines the controller (like IngressClass)
- **Gateway**: Defines listeners and TLS (like Ingress infrastructure)
- **HTTPRoute**: Defines routing rules (like Ingress rules)

**Migration Mapping:**
```
Ingress → Gateway + HTTPRoute
  spec.tls → Gateway.spec.listeners[].tls
  spec.rules → HTTPRoute.spec.rules
```

</details>

---

### Step 2: Create the Gateway Resource

Create a Gateway named `web-gateway` in the `web-app` namespace:

**Requirements:**
- Name: `web-gateway`
- Namespace: `web-app`
- GatewayClass: `nginx-class`
- Listener name: `https`
- Protocol: `HTTPS`
- Port: `443`
- Hostname: `gateway.web.k8s.local`
- TLS mode: `Terminate`
- TLS certificateRef: `web-tls-secret`

<details>
<summary>💡 Hint: Gateway YAML Structure</summary>

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: web-gateway
  namespace: web-app
spec:
  gatewayClassName: nginx-class
  listeners:
  - name: https
    protocol: HTTPS
    port: 443
    hostname: gateway.web.k8s.local
    tls:
      mode: Terminate
      certificateRefs:
      - kind: Secret
        name: web-tls-secret
```

</details>

**Create the Gateway:**

```bash
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: web-gateway
  namespace: web-app
spec:
  gatewayClassName: nginx-class
  listeners:
  - name: https
    protocol: HTTPS
    port: 443
    hostname: gateway.web.k8s.local
    tls:
      mode: Terminate
      certificateRefs:
      - kind: Secret
        name: web-tls-secret
EOF
```

**Verify:**

```bash
kubectl get gateway -n web-app
kubectl describe gateway web-gateway -n web-app
```

---

### Step 3: Create the HTTPRoute Resource

Create an HTTPRoute named `web-route` in the `web-app` namespace:

**Requirements:**
- Name: `web-route`
- Namespace: `web-app`
- Parent ref: Gateway `web-gateway`
- Hostname: `gateway.web.k8s.local`
- Path: `/` (Prefix)
- Backend: Service `web-service` port `80`

<details>
<summary>💡 Hint: HTTPRoute YAML Structure</summary>

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: web-route
  namespace: web-app
spec:
  parentRefs:
  - name: web-gateway
  hostnames:
  - gateway.web.k8s.local
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /
    backendRefs:
    - name: web-service
      port: 80
```

</details>

**Create the HTTPRoute:**

```bash
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: web-route
  namespace: web-app
spec:
  parentRefs:
  - name: web-gateway
  hostnames:
  - gateway.web.k8s.local
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /
    backendRefs:
    - name: web-service
      port: 80
EOF
```

**Verify:**

```bash
kubectl get httproute -n web-app
kubectl describe httproute web-route -n web-app
```

---

### Step 4: Verify the Migration

Check all Gateway API resources:

```bash
kubectl get gatewayclass
kubectl get gateway -n web-app
kubectl get httproute -n web-app
```

Compare with the original Ingress:

```bash
kubectl get ingress -n web-app
```

**Success criteria:**
- ✅ Gateway `web-gateway` exists in `web-app` namespace
- ✅ Gateway uses `nginx-class` GatewayClass
- ✅ Gateway has HTTPS listener on port 443
- ✅ Gateway hostname is `gateway.web.k8s.local`
- ✅ Gateway uses TLS secret `web-tls-secret`
- ✅ HTTPRoute `web-route` exists in `web-app` namespace
- ✅ HTTPRoute references Gateway `web-gateway`
- ✅ HTTPRoute hostname is `gateway.web.k8s.local`
- ✅ HTTPRoute routes `/` to `web-service` port 80

You've successfully migrated from Ingress to Gateway API!
