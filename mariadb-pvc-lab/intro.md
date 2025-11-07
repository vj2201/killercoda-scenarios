> 💡 **Free CKA labs take time to create!** Please [subscribe to my YouTube channel](https://youtube.com/channel/UC2ckWW5aAtV0KISxk6g8rCg?sub_confirmation=1) and [buy me a coffee](https://buymeacoffee.com/vjaarohi) ☕ to support more content!

# PVC - MariaDB Data Recovery

## Scenario
A PersistentVolume exists with MariaDB data, but no deployment is using it. You need to create a PVC and configure a deployment to mount this storage.

## Your Task
1. Apply the PVC template at `/root/pvc.yaml` (already configured for 250Mi)
2. Edit `/root/mariadb-deploy.yaml` to replace `emptyDir` with the PVC
3. Apply the deployment and verify MariaDB is running with persistent storage

## Success Criteria
- PVC `mariadb-pvc` is **Bound** to PersistentVolume `mariadb-pv`
- MariaDB pod is **Running** in namespace `mariadb`
- Volume mount uses the PVC (not emptyDir)

## Files Provided
- `/root/pvc.yaml` - PersistentVolumeClaim template (ready to apply)
- `/root/mariadb-deploy.yaml` - Deployment with emptyDir (needs editing)

Click **"Next"** for the solution.
