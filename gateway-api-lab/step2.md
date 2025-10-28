Create a Gateway named `web-gateway` that preserves the HTTPS listener and TLS cert from the existing Ingress. Use the pre-installed `GatewayClass` `nginx-class` and host `gateway.web.k8s.local`.

Apply this manifest:

```
kubectl apply -f - <<'YAML'
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: web-gateway
  namespace: web-migration
spec:
  gatewayClassName: nginx-class
  listeners:
  - name: https
    hostname: gateway.web.k8s.local
    port: 443
    protocol: HTTPS
    tls:
      mode: Terminate
      certificateRefs:
      - kind: Secret
        name: web-tls
YAML
```

Check the Gateway:

`kubectl get gateway -n web-migration -o wide`

Quick validation (Ready condition should be True):

`kubectl -n web-migration get gateway web-gateway -o jsonpath='{range .status.conditions[*]}{.type}={.status}{"\n"}{end}'`

Note: Controller must support `nginx-class` to surface Ready=True.
