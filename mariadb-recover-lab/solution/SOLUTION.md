Solution outline

1) Create the PVC (250Mi, RWO) to bind to the retained PV:
   cat <<'EOF' | kubectl apply -f -
   apiVersion: v1
   kind: PersistentVolumeClaim
   metadata:
     name: mariadb
     namespace: mariadb
   spec:
     accessModes: [ReadWriteOnce]
     resources:
       requests:
         storage: 250Mi
     storageClassName: ""
   EOF

2) Edit /root/mariadb-deploy.yaml to use the PVC:
   - Replace the volume section:
     volumes:
     - name: data
       persistentVolumeClaim:
         claimName: mariadb

3) Apply and wait:
   kubectl apply -f /root/mariadb-deploy.yaml
   kubectl -n mariadb rollout status deploy/mariadb --timeout=120s

4) Verify data is present from the PV:
   POD=$(kubectl -n mariadb get pod -l app=mariadb -o jsonpath='{.items[0].metadata.name}')
   kubectl -n mariadb exec "$POD" -- ls -l /var/lib/mysql/lab-proof/keepme.txt

Checks:
- kubectl get pv,pvc -A  # PVC should be Bound to the single PV
- kubectl -n mariadb get deploy,po  # Deployment Ready

