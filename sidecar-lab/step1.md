Run this command to create the base Deployment (no shared volume yet):

```
kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
  labels:
    app: wordpress
spec:
  replicas: 1
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      containers:
      - name: main-app
        image: busybox:stable
        command: ["/bin/sh", "-c"]
        args:
          - while true; do echo "WordPress app writing logs..." >> /var/log/wordpress.log; sleep 5; done
YAML
```

Verify the pod is running:

`kubectl get pods -l app=wordpress`
