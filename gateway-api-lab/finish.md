Great job migrating the Ingress to Gateway API!

- You created `Gateway` `web-gateway` using `GatewayClass` `nginx-class` with HTTPS TLS termination for `gateway.web.k8s.local`.
- You created `HTTPRoute` `web-route` that preserves the original `/` and `/api` path routing.

Next steps
- Optional: remove the old Ingress once you confirm the controller routes traffic via Gateway API.
- Cleanup lab resources: `bash gateway-api-lab/cleanup.sh`
- Explore multiple listeners, cross-namespace `HTTPRoute`, or `TLSRoute`.

