> 💡 **Free CKA labs take time to create!** Please [subscribe to my YouTube channel](https://youtube.com/channel/UC2ckWW5aAtV0KISxk6g8rCg?sub_confirmation=1) and [buy me a coffee](https://buymeacoffee.com/vjaarohi) ☕ to support more content!

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
