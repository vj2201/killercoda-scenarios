Create the base WordPress Deployment (same style as other labs), then scale down to edit resources safely.

Apply the deployment:

```
kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
  labels:
    app: wordpress
spec:
  replicas: 3
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      initContainers:
      - name: init-setup
        image: busybox:stable
        command: ["/bin/sh", "-c"]
        args: ["echo init done; sleep 1"]
      containers:
      - name: main-app
        image: busybox:stable
        command: ["/bin/sh", "-c"]
        args:
          - while true; do echo "WordPress app running..."; sleep 5; done
YAML
```

Wait for rollout (best-effort):

`kubectl rollout status deploy/wordpress --timeout=120s || true`

Now scale down to 0 replicas before editing resource requests/limits:

`kubectl scale deploy wordpress --replicas=0`

`kubectl rollout status deploy/wordpress --timeout=120s`

Confirm there are no running Pods:

`kubectl get pods -l app=wordpress`
