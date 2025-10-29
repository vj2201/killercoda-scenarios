Create a PersistentVolumeClaim named `mariadb` with ReadWriteOnce access mode and 250Mi storage.

Create the PVC:

```bash
kubectl apply -f - <<'YAML'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mariadb
  namespace: mariadb
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 250Mi
YAML
```

**Important**: The PVC requests 250Mi but the PV has 500Mi. This is fine - the PVC will bind to the PV because:
1. StorageClass matches (`manual`)
2. Access mode matches (ReadWriteOnce)
3. PV capacity (500Mi) >= PVC request (250Mi)

Verify the PVC was created:

`kubectl get pvc -n mariadb`

You should see `mariadb` PVC with STATUS `Bound`

Check binding details:

`kubectl describe pvc mariadb -n mariadb`

Verify the PV is now bound:

`kubectl get pv mariadb-pv`

STATUS should change from `Available` to `Bound`

**Understanding PV/PVC binding:**
- PVC searches for PV matching: storageClass, accessMode, and capacity
- Binding is automatic if match found
- Once bound, PV is reserved for that PVC
- With Retain policy, data persists even if PVC is deleted

In the next step, you'll edit the deployment to use this PVC.
