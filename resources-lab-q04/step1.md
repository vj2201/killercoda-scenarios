Verify the base WordPress Deployment was created by the setup script, then scale down to 0 replicas before editing resource requests/limits.

Check the deployment exists:

`kubectl get deploy wordpress`

Verify it has 3 replicas and includes an init container:

`kubectl describe deploy wordpress | grep -A2 "Init Containers\|Replicas"`

Now scale down to 0 replicas to safely edit resources:

`kubectl scale deploy wordpress --replicas=0`

`kubectl rollout status deploy/wordpress --timeout=120s`

Confirm there are no running Pods:

`kubectl get pods -l app=wordpress`

You should see "No resources found" - this confirms the deployment is scaled to 0 and ready for editing.
