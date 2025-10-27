Verify the deployment and logs from the sidecar container.

- Check pods:

`kubectl get pods -l app=synergy`

- Stream logs from the sidecar:

`kubectl logs deployment/synergy-deployment -c sidecar -f`

- Run automated checks:

`bash /root/verify.sh`

You should see the log lines produced by the main container, and the verify script should report PASS for name, image, volume mount, and command.
