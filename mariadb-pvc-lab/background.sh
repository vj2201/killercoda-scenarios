#!/bin/bash
set -e

echo "🚀 Setting up CKA PersistentVolume Recovery Lab"

# Create namespace
echo "[info] Creating mariadb namespace..."
kubectl create namespace mariadb --dry-run=client -o yaml | kubectl apply -f -

# Create directory for PV on the node
echo "[info] Creating data directory for PersistentVolume..."
mkdir -p /mnt/data/mariadb

# Create PersistentVolume (Available, waiting to be claimed)
echo "[info] Creating PersistentVolume..."
kubectl apply -f - <<'YAML'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mariadb-pv
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 500Mi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: "/mnt/data/mariadb"
YAML

# Create PVC template file
echo "[info] Creating PVC template at /root/pvc.yaml..."
cat > /root/pvc.yaml <<'YAML'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mariadb-pvc
  namespace: mariadb
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  storageClassName: manual
  resources:
    requests:
      storage: 250Mi
YAML

# Create deployment template file with emptyDir (to be replaced with PVC)
echo "[info] Creating deployment template at /root/mariadb-deploy.yaml..."
cat > /root/mariadb-deploy.yaml <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mariadb
  namespace: mariadb
  labels:
    app: mariadb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mariadb
  template:
    metadata:
      labels:
        app: mariadb
    spec:
      containers:
      - name: mariadb
        image: mariadb:11
        env:
        - name: MYSQL_ALLOW_EMPTY_PASSWORD
          value: "yes"
        ports:
        - containerPort: 3306
          name: mysql
        volumeMounts:
        - name: data
          mountPath: /var/lib/mysql
      volumes:
      - name: data
        emptyDir: {}
YAML

echo "[info] Verifying PersistentVolume status..."
kubectl get pv mariadb-pv || true

echo "✅ Setup complete. Scenario ready:"
echo "   - PersistentVolume 'mariadb-pv' is Available (500Mi, ReadWriteOnce)"
echo "   - PVC template at /root/pvc.yaml (ready to apply)"
echo "   - Deployment template at /root/mariadb-deploy.yaml (uses emptyDir)"
echo "   - Task: Apply PVC, then edit deployment to use PVC instead of emptyDir"
