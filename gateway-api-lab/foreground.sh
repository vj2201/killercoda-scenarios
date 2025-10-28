#!/bin/bash
set -euo pipefail

echo "=================================================="
echo "=== Gateway API Migration Lab: Auto Setup     ==="
echo "=== Start: $(date)                           ==="
echo "=================================================="

ns=web-migration
echo "[info] Ensuring namespace $ns exists"
kubectl get ns "$ns" >/dev/null 2>&1 || kubectl create ns "$ns"

if ! kubectl -n "$ns" get deploy web-deploy >/dev/null 2>&1; then
  echo "[info] Applying baseline app and Ingress"
  if [ -x /root/setup.sh ]; then
    echo "[info] running /root/setup.sh"
    bash /root/setup.sh || true
  elif [ -f ./setup.sh ]; then
    echo "[info] running local ./setup.sh"
    bash ./setup.sh || true
  else
    echo "[warn] setup.sh not found; applying inline manifest fallback"
    kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Namespace
metadata:
  name: web-migration
---
apiVersion: v1
kind: Secret
metadata:
  name: web-tls
  namespace: web-migration
type: kubernetes.io/tls
data:
  tls.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURlRENDQWJpZ0F3SUJBZ0lKQUtVb2JxTmx1eGZvTUEwR0NTcUdTSWIzRFFFQkN3VUFNQkl4RFRBTEJnTlYKQkFZVEFrNU5hV1Z1ZENCRFFUQWVGdzB5TVRBeE1USXdOVEl4TURoYUZ3MHlNVEF4TVRJd05USXhNRGhhTURJeApGekFWQmdOVkJBb1REbk41YzNSbGJTMXpkbU13SGhjTk1qRXhNREl4T0RjMk9EUTNXaGNOTWpFeE1ESXhPRGMyCk9EUTNXakFZTVJZd0ZBWURWUVFEREJwQmNIQnNaV05wYzI5bE1TNWxlR0Z0Y0d4bExtTnZiVEVWTUJNR0ExVUUKQ3hNSmIzQmxibk5vYVdOaGRHVXhIakFjQmdOVkJBTVRFMFJ5WldOdmJtVnlNUlV3RXdZRFZRUURFd2R5WldOdgpiV3h6YVc5dUlFTkJNQjRYRFRFNE1URXdNVEUwTkRBek1Wb1hEVEk0TVRFd01URTBOREF6TVZvd0ZURVRNQkVHCkExVUVDaE1NYzNsemRHVnRZbVZ5Ym1WMExXTmhkR1V4RHpBYkJnTlZCQU1URjI5dVpXNTBMV05oZEdVd0hoY2cKTWpFeE1ESXhPRGMyT0RRM1doY05NakV4TURJeE9EYzJPRFEzV2pBWU1SY3dGUVlEVlFRRERBZEJjSEJzWldOcApjMjlsTVM1bGVHRnRjR3hsTG1OdmJURXdNQ0FHQTFVRUF3d0tiM0JsYm5Ob2FXTmhkR1V4RHpBTkJnTlZCQU1UCkYyOXVaVzUwTFdOaGRHVXdIaGNOTWpFeE1ESXhPRGMyT0RRM1doZ1BNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0SUQKQmdOVkhSRUVIU1F3Z2dJd0RRWUpLb1pJaHZjTkFRRUxCUUF3UWpFTE1Ba0dBMVVFQmhNQ1ZWTXhFakFRQmdOVgpCQW9UQlhCbWRtVnlhV1Z6ZEdadmNtMWhkR2x2Ymk1amIyMHdnZ0VpTUEwR0NTcUdTSWIzRFFFQkN3VUFBNElDCkFRQ2lxdXpnZ0YrcWoydWJxR1lJZm5mYnlmT0R4R3BTN1F5b0FQODA3b1h6dWx3Z2RqS0dNaEphMnpJTUpUR20KMmFsQ3N6SkI4Q21ueHh6SndGQ20vSVFCbDdtbW5kc2pvM0Vxd2VNRjRja3BKS1NQWDNsN0U1c3pOdk5VSnBlcQp6VkJyWWF1dTB6TXh6STl1bEczZDkwWTdFbXhHY1BRK0lQNGQvbzNKT2RoWng2c3N1L3J3UEN0UGI5Z3drT3o0Ck5NS1N3MUwrMUZVcTg3d3hNU1dFMVo2bjd2Wm9SWVhzZzN0ZXM2cWZIa01Yd0Z0a0JPN2MycTlXSkRVVS9jWUsKZk9pM0R5TjZkLzYxSkczR0FoOGUwRllhV1N5L0NPUkZDUDBxK2liM1hDdm1RZklselF0N2szUkFSdzVEb2hBTwpNR3JQYzZ6UG45Z2JyK2VvT1Axc2s3VU5oQ0lNYWxTUDVxYzR1ODZyZ2JzWlR4N0ovM0Iyc2F6Z0lIZVZQbTQ5CjlpM1hvUVU4Z2lKTjZYNVdOUWVhVFl4UUlEQVFBQm8yRXdYekFPQmdOVkhROEJBZjhFQkFNQ0JhQXdFd1lEVlIKRkFRSC9CQVlUQkFJd0FEQU9CZ05WSFE4QkFmOEVCQU1DQmFBd0V3WURWUjBmQkRVd0F3RUIvd1FGTUFNQkFmOEEKQmdOVkhTTUVHREFXZ0JQUUR4V3BvWnpvQUorbUx2bS8xOHd0bUFlTkhvTHdEUVlKS29aSWh2Y05BUUVMQlFBdwpBdlI0L1E0TEpGNlZkM1o2NmttS3g3TVlYcy8vN3hWcTFlQ2pXc0VRSzUyU2d3UGx3NVlGVmtoS1VZPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
  tls.key: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb3dJQkFBS0NBUUVBMkRVeHk4c1JDei9DU0NDUGtQYUwvaURlQ3JWYnpkaFg1aDg2T0o0cCtUVnF1QmVaCkRyYVZOdXh2eFBSZ0h4b1Q5T3p2Q3g5dE1TOGZRTkZxZ3FVNWdQbEJCcEpJdFJTN3RUMUlkRy9nZnpJd2l0dGQKS0tsZ2t3cThJMkZqTk1xNFRRa29TTjVNSHZyOU9ZbnhPU08rNHIzd21tV1d0Zy9oM1g2QmJ2bGZHSWhYVkUwVQpWQ09SaXdDV2FLc1kvOGx4Y2JOMk4vaUtqN2VyK3B2dmEyT0psVmhJN2YyM0JYdWxjTTRKM1JoaURNbWZFdDg0CkYwWmZCZGpGU1Z6eWw5cWVlS2w0Zk5rV0pGZ0FqWmRhazBjZFBMbWVDRXlDSkIvNnJtMW1wVm9JS21oUlNydm8Kc0R2UHVlRktaZG8vWGRtVng5R3BJRnhWdlhZekdqMGdUV2kxZGFlb3BObitYbXkzQjhSTzJOc2RNNG40MWxZegpIRWVRNVpydEdCTUhnYlJ0NnhaM0RxOTRlbnlPRW80MkhpZ3Rpd2kvcEw0N29pM2ZnL0ljWmUvVFFJREFRQUJBCi0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg==
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deploy
  namespace: web-migration
  labels:
    app: web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: web
        image: hashicorp/http-echo:1.0.0
        args: ["-text=Hello from web"]
        ports:
        - containerPort: 5678
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-deploy
  namespace: web-migration
  labels:
    app: api
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
      - name: api
        image: hashicorp/http-echo:1.0.0
        args: ["-text=Hello from api"]
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: web-svc
  namespace: web-migration
spec:
  selector:
    app: web
  ports:
  - name: http
    port: 80
    targetPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: api-svc
  namespace: web-migration
spec:
  selector:
    app: api
  ports:
  - name: http
    port: 8080
    targetPort: 5678
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web
  namespace: web-migration
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - gateway.web.k8s.local
    secretName: web-tls
  rules:
  - host: gateway.web.k8s.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-svc
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-svc
            port:
              number: 8080
YAML
  fi
fi

kubectl -n "$ns" get deploy,svc,ingress || true

echo "=================================================="
echo "=== Next: Create Gateway (step 2)             ==="
echo "=== Then: Create HTTPRoute (step 3)           ==="
echo "=================================================="
