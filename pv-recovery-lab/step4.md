Apply the updated deployment and verify MariaDB is running and stable.

Apply the deployment:

`kubectl apply -f /root/mariadb-deploy.yaml`

Wait for the deployment to roll out:

`kubectl rollout status deployment/mariadb -n mariadb`

Verify the deployment is running:

`kubectl get deploy -n mariadb`

You should see: `READY 1/1`

Check pods are running:

`kubectl get pods -n mariadb`

Pod should be in `Running` status.

Verify the pod is using the PVC:

`kubectl describe pod -n mariadb -l app=mariadb | grep -A5 "Volumes:"`

You should see the `mariadb-storage` volume mounted.

Check PVC is still bound:

`kubectl get pvc -n mariadb`

STATUS should be `Bound`.

**Verify data persistence (optional):**

Connect to MariaDB and create test data:

```bash
kubectl exec -it -n mariadb deployment/mariadb -- mysql -ppassword123 -e "SHOW DATABASES;"
```

You should see the `testdb` database.

**Test recovery simulation (optional):**

Delete the pod to simulate failure:

`kubectl delete pod -n mariadb -l app=mariadb`

The Deployment will automatically create a new pod.

Verify new pod comes up:

`kubectl get pods -n mariadb --watch`

(Press Ctrl+C to stop watching)

Check database still exists:

```bash
kubectl exec -it -n mariadb deployment/mariadb -- mysql -ppassword123 -e "SHOW DATABASES;"
```

The data persists because it's stored in the PersistentVolume!

**Success criteria:**
- ✅ PVC `mariadb` exists and is Bound
- ✅ PV `mariadb-pv` is Bound to the PVC
- ✅ Deployment `mariadb` is running (1/1 ready)
- ✅ Pod has volume mounted at /var/lib/mysql
- ✅ MariaDB is accessible and functional

You've successfully recovered the MariaDB deployment with persistent storage!
