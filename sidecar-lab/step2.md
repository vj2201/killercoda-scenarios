Edit the deployment to add a sidecar container that tails the shared log file in `/var/log` using the same `emptyDir` volume.

Open the deployment in your editor:

`kubectl edit deployment synergy-deployment`

Add a sidecar container like this (example):

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
        args: ["tail -F /var/log/synergy-deployment.log"]
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

