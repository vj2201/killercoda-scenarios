Check the deployment and stream logs from the sidecar container.

- Check pods:

`kubectl get pods -l app=wordpress`

- Stream logs from the sidecar:

`kubectl logs deployment/wordpress -c sidecar -f`

You should see the log lines produced by the main container.
