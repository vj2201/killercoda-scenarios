Goal: Re-establish MariaDB using the retained PersistentVolume while preserving data.

What’s provided:
- Namespace: `mariadb`
- A single PV with Retain policy and 250Mi capacity
- Deployment template to edit: `/root/mariadb-deploy.yaml`
- The PV contains a marker file at `lab-proof/keepme.txt` to verify persistence

Tasks:
1) Inspect the existing PV:
   kubectl get pv -o wide

2) Create the PVC in the `mariadb` namespace (250Mi, RWO):
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
     storageClassName: ""   # bind to the preexisting PV without a StorageClass
   EOF

3) Edit the deployment to use the PVC:
   - Open `/root/mariadb-deploy.yaml`
   - Replace the `emptyDir: {}` volume with a `persistentVolumeClaim: { claimName: mariadb }`

4) Apply the deployment and wait for readiness:
   kubectl apply -f /root/mariadb-deploy.yaml
   kubectl -n mariadb rollout status deploy/mariadb --timeout=120s

5) Verify the preserved data is visible from the pod:
   POD=$(kubectl -n mariadb get pod -l app=mariadb -o jsonpath='{.items[0].metadata.name}')
   kubectl -n mariadb exec "$POD" -- ls -l /var/lib/mysql/lab-proof/keepme.txt

Notes:
- If the PVC remains Pending, ensure the `storageClassName: ""` is set to match the PV (no StorageClass) and that capacity/accessModes match.
- The hostPath PV is for lab purposes (single-node); production clusters should use a proper storage provisioner.

