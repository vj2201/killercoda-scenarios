Verify the baseline environment was created by the setup script. The setup includes:
- Namespace `web-migration`
- Two deployments (`web-deploy`, `api-deploy`) with services
- An Ingress named `web` with HTTPS for host `gateway.web.k8s.local`
- A TLS secret named `web-tls`

Verify all resources exist:

`kubectl get ns,deploy,svc,ingress -n web-migration`

Verify the Ingress configuration (host and TLS):

`kubectl -n web-migration get ingress web -o jsonpath='{.spec.tls[0].hosts[0]}{" "}{.spec.tls[0].secretName}{"\n"}'`

Expected output: `gateway.web.k8s.local web-tls`

Verify the routing paths (`/` and `/api`):

`kubectl -n web-migration get ingress web -o jsonpath='{range .spec.rules[0].http.paths[*]}{.path}{" -> "}{.backend.service.name}{":"}{.backend.service.port.number}{"\n"}{end}'`

Expected output:
```
/ -> web-svc:80
/api -> api-svc:8080
```

Now that you've verified the current Ingress setup, you'll migrate it to Gateway API in the following steps.
