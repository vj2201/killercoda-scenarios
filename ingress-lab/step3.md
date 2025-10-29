Create an Ingress resource named `echo` for `http://example.org/echo` routing to the `echo-service`.

**Option 1: Imperative Command (FASTEST for exam!)**

```bash
kubectl create ingress echo \
  --namespace=echo-sound \
  --class=nginx \
  --rule="example.org/echo=echo-service:8080"
```

This single command creates the entire Ingress - much faster than writing YAML!

**Option 2: Declarative YAML (if you need more control)**

Create the Ingress manifest:

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

**Understanding the Ingress:**
- `ingressClassName: nginx`: Uses nginx ingress controller
- `host: example.org`: Matches requests with Host header "example.org"
- `path: /echo`: Matches requests starting with /echo
- `pathType: Prefix`: Matches /echo, /echo/, /echo/anything
- Backend points to `echo-service` on port 8080

Verify the Ingress was created:

`kubectl get ingress -n echo-sound`

View Ingress details:

`kubectl describe ingress echo -n echo-sound`

Check for the ADDRESS field - it may take a minute to populate.

Get Ingress details:

`kubectl get ingress echo -n echo-sound -o wide`

**Note about pathType:**
- `Prefix`: Matches /echo, /echo/, /echo/test
- `Exact`: Only matches /echo exactly
- `ImplementationSpecific`: Depends on ingress controller

For this task, `Prefix` is appropriate since we want /echo and potential sub-paths to work.

In the next step, you'll test the Ingress.
