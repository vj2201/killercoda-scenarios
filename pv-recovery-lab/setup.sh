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

# Create deployment template file WITHOUT volume configuration
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
        image: mariadb:10.6
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "password123"
        - name: MYSQL_DATABASE
          value: "testdb"
        ports:
        - containerPort: 3306
          name: mysql
YAML

echo "[info] Verifying PersistentVolume status..."
kubectl get pv mariadb-pv || true

echo "✅ Setup complete. Scenario ready:"
echo "   - PersistentVolume 'mariadb-pv' is Available (500Mi, ReadWriteOnce)"
echo "   - Deployment template at /root/mariadb-deploy.yaml"
echo "   - You need to: Create PVC, Edit deployment, Apply deployment"
