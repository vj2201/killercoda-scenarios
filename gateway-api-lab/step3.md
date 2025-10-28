Create an HTTPRoute named `web-route` that preserves the existing Ingress routing rules for host `gateway.web.k8s.local` and attaches to the `web-gateway`.

Apply this manifest:

```
kubectl apply -f - <<'YAML'
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: web-route
  namespace: web-migration
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
    - name: web-svc
      port: 80
  - matches:
    - path:
        type: PathPrefix
        value: /api
    backendRefs:
    - name: api-svc
      port: 8080
YAML
```

Confirm the route:

`kubectl get httproute -n web-migration -o wide`

Quick validation (parent Ready=True and host/path rules):

`kubectl -n web-migration get httproute web-route -o jsonpath='{range .status.parents[*].conditions[*]}{.type}={.status}{"\n"}{end}'`

`kubectl -n web-migration get httproute web-route -o jsonpath='{.spec.hostnames[0]}{"\n"}{range .spec.rules[*]}{range .matches[*]}{.path.type}{":"}{.path.value}{"\n"}{end}{end}'`
