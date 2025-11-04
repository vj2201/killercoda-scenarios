# Solution

## Step 1: Create the PersistentVolumeClaim
```bash
cat > /tmp/pvc.yaml << EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mariadb-pvc
  namespace: mariadb
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  resources:
    requests:
      storage: 250Mi
EOF
kubectl apply -f /tmp/pvc.yaml
kubectl get pvc -n mariadb
```

## Step 2: Update Deployment and Apply
```bash
sed -i 's/emptyDir: {}/name: mariadb-storage/g' /root/mariadb-deploy.yaml
cat >> /root/mariadb-deploy.yaml << 'EOF'
        volumeMounts:
        - name: mariadb-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mariadb-storage
        persistentVolumeClaim:
          claimName: mariadb-pvc
EOF
kubectl apply -f /root/mariadb-deploy.yaml
kubectl get pods -n mariadb
```

## Explanation
The PVC acts as a bridge between the Deployment and the physical PersistentVolume. By specifying the PVC in volumeMounts, the MariaDB pod can access the retained storage even after deletion.

✅ **Done!** MariaDB is now running with persistent storage bound to a reclaimed volume.
