Verify the base WordPress Deployment was created by the setup script.

Check the deployment exists:

`kubectl get deploy wordpress`

Verify the pod is running:

`kubectl get pods -l app=wordpress`

Check the deployment configuration (note: it has a volume but no sidecar yet):

`kubectl describe deploy wordpress`

You should see:
- 1 replica running
- A main container named `main-app` writing logs to `/var/log/wordpress.log`
- A volume named `log-volume` mounted at `/var/log`

In the next step, you'll edit this deployment to add a sidecar container that reads those logs.
