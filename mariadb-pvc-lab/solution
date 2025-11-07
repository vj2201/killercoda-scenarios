# Solution

## Step 1: Apply the PersistentVolumeClaim

The PVC template is already created at `/root/pvc.yaml`. Apply it:

```bash
kubectl apply -f /root/pvc.yaml
```

**Verify PVC is bound:**
```bash
kubectl get pvc -n mariadb
```

Expected output: Status should be `Bound` to `mariadb-pv`

## Step 2: Edit Deployment to Use PVC

The deployment at `/root/mariadb-deploy.yaml` currently uses `emptyDir`. Replace it with the PVC:

```bash
kubectl edit -f /root/mariadb-deploy.yaml
```

Or use `sed` to replace emptyDir with PVC:

```bash
sed -i 's/emptyDir: {}/persistentVolumeClaim:\n          claimName: mariadb-pvc/' /root/mariadb-deploy.yaml
```

**The volumes section should look like this:**
```yaml
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: mariadb-pvc
```

## Step 3: Apply the Deployment

```bash
kubectl apply -f /root/mariadb-deploy.yaml
```

**Verify pod is running:**
```bash
kubectl get pods -n mariadb
kubectl describe pod -n mariadb
```

Expected: Pod status `Running`, using PVC `mariadb-pvc`

## Explanation

**PersistentVolumeClaim (PVC)** acts as a request for storage. It binds to an available PersistentVolume that matches the requirements (size, access mode, storage class).

**Key Points:**
- PV `mariadb-pv` was pre-created with `Retain` policy
- PVC `mariadb-pvc` requests 250Mi (PV has 500Mi, so it satisfies the request)
- Deployment mounts the PVC at `/var/lib/mysql` for MariaDB data

✅ **Done!** MariaDB is now running with persistent storage that survives pod restarts.
