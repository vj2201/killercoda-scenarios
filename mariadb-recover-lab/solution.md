# Solution

## Step 1: Create PersistentVolumeClaim
```bash
cat > /tmp/pvc.yaml << EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mariadb-data
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 250Mi
EOF
kubectl apply -f /tmp/pvc.yaml
kubectl get pvc
```

## Step 2: Configure Deployment with Volume Mount
```bash
kubectl set volume deployment/mariadb --add --name=mysql-storage \
  --type=persistentVolumeClaim --claim-name=mariadb-data \
  --mount-path=/var/lib/mysql
kubectl apply -f /root/mariadb-deploy.yaml
kubectl get pods
kubectl exec -it deployment/mariadb -- ls -la /var/lib/mysql/lab-proof/
```

## Explanation
The PVC mounted at `/var/lib/mysql` provides persistent storage where MariaDB stores its database files. This allows the lab-proof directory content to persist across pod restarts.

✅ **Done!** MariaDB is running with persistent data volume mounted successfully.
