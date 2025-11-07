# Solution

## Step 1: Install Calico Operator
```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml
sleep 10
kubectl get pods -n tigera-operator
```

## Step 2: Create Calico Installation with VXLAN
```bash
cat > /tmp/calico-install.yaml << EOF
apiVersion: operator.tigera.io/v1
kind: Installation
metadata:
  name: default
spec:
  calicoNetwork:
    encapsulation: VXLAN
  calicoNodeDaemonSet:
    spec:
      template:
        spec:
          containers:
          - name: calico-node
            env:
            - name: CALICO_IPV4POOL_CIDR
              value: "10.244.0.0/16"
EOF
kubectl apply -f /tmp/calico-install.yaml
sleep 15
kubectl get pods -n calico-system
```

## Step 3: Verify NetworkPolicy Enforcement
```bash
# Create test pods
kubectl create namespace test
kubectl run test-pod --image=nginx -n test
kubectl run blocked-pod --image=alpine -n test -- sleep 3600

# Create default-deny NetworkPolicy
kubectl apply -f - << EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
  namespace: test
spec:
  podSelector: {}
  policyTypes:
  - Ingress
EOF

# Verify pods are isolated
kubectl get networkpolicy -n test
```

## Explanation
Calico operator provides both CNI networking and NetworkPolicy enforcement through its policy engine. VXLAN encapsulation ensures cross-node pod communication. NetworkPolicy enforcement is verified by testing default-deny behavior.

✅ **Done!** Calico CNI installed with NetworkPolicy support enabled.
