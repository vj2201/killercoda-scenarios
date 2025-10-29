First, scale down the Deployment to stop Pods safely before changing resources.

Commands:

`kubectl get deploy wordpress`

`kubectl scale deploy wordpress --replicas=0`

`kubectl rollout status deploy/wordpress --timeout=120s`

Confirm there are no running Pods:

`kubectl get pods -l app=wordpress`

