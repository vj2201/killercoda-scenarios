# Add Sidecar Container

## Scenario
A deployment `wordpress` exists with a main container writing logs to `/var/log/wordpress.log` using an emptyDir volume.

## Your Task
Edit the deployment to add a sidecar container that:
1. Uses image `busybox:stable`
2. Tails the log file from the shared volume
3. Shares the same `log-volume` (emptyDir)

## Success Criteria
- Deployment has 2 containers (main-app + sidecar)
- Both containers mount the same log-volume
- Sidecar logs show the wordpress.log output

Click **"Next"** for the solution.
