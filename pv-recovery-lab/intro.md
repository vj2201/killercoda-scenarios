# Persistent Volume Recovery

## Scenario
A MariaDB deployment was deleted but the data persists. You need to recover the deployment by creating a PVC and reconfiguring the storage.

## Your Task
1. Create a PersistentVolumeClaim (250Mi, RWO, storageClass: manual)
2. Edit `/root/mariadb-deploy.yaml` to use the new PVC instead of emptyDir
3. Apply the deployment and verify it's running

## Success Criteria
- PVC named `mariadb-pvc` is bound to the PersistentVolume
- MariaDB Deployment is in Running state
- Data persists across pod restarts

Click **"Next"** for the solution.
