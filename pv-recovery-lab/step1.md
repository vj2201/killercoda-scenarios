Verify the PersistentVolume exists and check the deployment template file.

List all PersistentVolumes:

`kubectl get pv`

You should see one PV: `mariadb-pv`

View details of the PersistentVolume:

`kubectl describe pv mariadb-pv`

Key details to note:
- **Status**: Available (not bound yet)
- **Capacity**: 500Mi
- **Access Modes**: RWO (ReadWriteOnce)
- **Reclaim Policy**: Retain
- **StorageClass**: manual

Check the deployment template file exists:

`ls -l /root/mariadb-deploy.yaml`

View the deployment template:

`cat /root/mariadb-deploy.yaml`

Notice: The deployment does NOT have volume configuration yet. You'll add this in Step 3.

Verify the namespace exists:

`kubectl get ns mariadb`

In the next step, you'll create a PVC to claim the PV.
