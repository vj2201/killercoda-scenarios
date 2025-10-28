Verify Gateway API resources and status. Note that actual data-plane routing depends on the installed controller for `nginx-class`.

- List resources:

`kubectl get gateway,httproute -n web-migration`

- Inspect conditions for readiness:

`kubectl describe gateway web-gateway -n web-migration`

`kubectl describe httproute web-route -n web-migration`

- (Optional) If your controller exposes an address, you can test with curl using SNI/Host header:

`curl -k --resolve gateway.web.k8s.local:443:CONTROLLER_IP https://gateway.web.k8s.local/`

`curl -k --resolve gateway.web.k8s.local:443:CONTROLLER_IP https://gateway.web.k8s.local/api`

Quick validation summary (expect Ready=True on both):

`kubectl -n web-migration get gateway web-gateway -o jsonpath='{range .status.conditions[*]}{.type}={.status}{"\n"}{end}'`

`kubectl -n web-migration get httproute web-route -o jsonpath='{range .status.parents[*].conditions[*]}{.type}={.status}{"\n"}{end}'`
