Edit the Deployment and set identical requests/limits on BOTH the init and main containers. Keep the same per‑pod values across all 3 Pods, leaving some headroom on the node (do not request 100% of allocatable).

Open the deployment in your editor:

`kubectl edit deploy wordpress`

Within `spec.template.spec`, add matching `resources` to BOTH the init container and the main container. Example values shown below; you may choose similar fair values (e.g., `300m` CPU and `256Mi` memory):

```
    spec:
      initContainers:
      - name: init-setup
        image: busybox:stable
        command: ["/bin/sh", "-c"]
        args: ["echo init done; sleep 1"]
        resources:
          requests:
            cpu: "300m"
            memory: "256Mi"
          limits:
            cpu: "300m"
            memory: "256Mi"
      containers:
      - name: main-app
        image: busybox:stable
        command: ["/bin/sh", "-c"]
        args:
          - while true; do echo "WordPress app running..."; sleep 5; done
        resources:
          requests:
            cpu: "300m"
            memory: "256Mi"
          limits:
            cpu: "300m"
            memory: "256Mi"
```

Notes:
- Use the exact same requests/limits for both init and main containers.
- Ensure 3 Pods together leave reasonable overhead so the node stays stable.
