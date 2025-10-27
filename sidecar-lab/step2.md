Edit the deployment to add a co-located container named `sidecar` using the `busybox:stable` image. The sidecar must tail the shared log file using the exact command:

`/bin/sh -c "tail -n+1 -f /var/log/synergy-deployment.log"`

Do not modify the existing container’s spec; only add the sidecar. Reuse the existing `log-volume` mounted at `/var/log`.

Open the deployment in your editor:

`kubectl edit deployment synergy-deployment`

Add a sidecar container like this (example snippet inside `spec.template.spec`):

```
      containers:
      - name: main-app
        image: busybox:stable
        command: ["/bin/sh", "-c"]
        args:
          - while true; do echo "Main app writing logs..." >> /var/log/synergy-deployment.log; sleep 5; done
        volumeMounts:
        - name: log-volume
          mountPath: /var/log
      - name: sidecar
        image: busybox:stable
        command: ["/bin/sh", "-c"]
        args: ["tail -n+1 -f /var/log/synergy-deployment.log"]
        volumeMounts:
        - name: log-volume
          mountPath: /var/log
```

Ensure the `volumes` section contains:

```
      volumes:
      - name: log-volume
        emptyDir: {}
```
