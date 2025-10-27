Run this command to create the base Deployment (no shared volume yet):

```
kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: synergy-deployment
  labels:
    app: synergy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: synergy
  template:
    metadata:
      labels:
        app: synergy
    spec:
      containers:
      - name: main-app
        image: busybox:stable
        command: ["/bin/sh", "-c"]
        args:
          - while true; do echo "Main app writing logs..." >> /var/log/synergy-deployment.log; sleep 5; done
YAML
```

Verify the pod is running:

`kubectl get pods -l app=synergy`
