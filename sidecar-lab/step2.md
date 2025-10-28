Edit the deployment to add a shared volume and a co-located container named `sidecar` using the `busybox:stable` image. The sidecar must tail the shared log file using the exact command:

`/bin/sh -c "tail -n+1 -f /var/log/wordpress.log"`

Do not change the existing container’s command. Add an `emptyDir` volume named `log-volume`, mount it at `/var/log` in BOTH containers, and add the sidecar.

Open the deployment in your editor:

`kubectl edit deployment wordpress`

Add the volume and sidecar like this (example snippet inside `spec.template.spec`):

```
      volumes:
      - name: log-volume
        emptyDir: {}
      containers:
      - name: main-app
        image: busybox:stable
        command: ["/bin/sh", "-c"]
        args:
          - while true; do echo "WordPress app writing logs..." >> /var/log/wordpress.log; sleep 5; done
        volumeMounts:
        - name: log-volume
          mountPath: /var/log
      - name: sidecar
        image: busybox:stable
        command: ["/bin/sh", "-c"]
        args: ["tail -n+1 -f /var/log/wordpress.log"]
        volumeMounts:
        - name: log-volume
          mountPath: /var/log
```

This ensures both containers share `/var/log` via the same `emptyDir`.
