Recommended choice: Calico (v3.28.2). Flannel does not enforce NetworkPolicy, so it fails requirement 2.

Install Calico from manifests:

1) Operator:
   kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml

2) Installation CR (adjust CIDR if needed):
   cat <<'EOF' | kubectl apply -f -
   apiVersion: operator.tigera.io/v1
   kind: Installation
   metadata:
     name: default
   spec:
     variant: Calico
     calicoNetwork:
       ipPools:
       - cidr: 192.168.0.0/16
         encapsulation: VXLAN
         natOutgoing: Enabled
         nodeSelector: all()
   EOF

3) (Optional) Calico API server:
   cat <<'EOF' | kubectl apply -f -
   apiVersion: operator.tigera.io/v1
   kind: APIServer
   metadata:
     name: default
   EOF

Verify:
  kubectl -n tigera-operator get pods
  kubectl -n calico-system get pods

Policy enforcement check (quick):
  # Create namespace, two pods and a service, then default-deny
  kubectl apply -f - <<'EOF'
  apiVersion: v1
  kind: Namespace
  metadata: { name: netcheck }
  ---
  apiVersion: v1
  kind: Pod
  metadata: { name: n1, namespace: netcheck, labels: { app: n1 } }
  spec:
    containers: [{ name: c, image: curlimages/curl:8.5.0, command: ["sh","-c"], args: ["sleep 36000"] }]
  ---
  apiVersion: v1
  kind: Pod
  metadata: { name: n2, namespace: netcheck, labels: { app: n2 } }
  spec:
    containers: [{ name: c, image: nginx:1.25, ports: [{containerPort: 80}] }]
  ---
  apiVersion: v1
  kind: Service
  metadata: { name: n2, namespace: netcheck }
  spec:
    selector: { app: n2 }
    ports: [{ port: 80, targetPort: 80 }]
  ---
  apiVersion: networking.k8s.io/v1
  kind: NetworkPolicy
  metadata: { name: default-deny, namespace: netcheck }
  spec: { podSelector: {}, policyTypes: [Ingress] }
  EOF

  # Fails due to deny
  kubectl -n netcheck exec n1 -- curl -sS --max-time 3 http://n2 || echo "blocked as expected"

  # Allow traffic from n1 -> n2 on 80
  kubectl apply -f - <<'EOF'
  apiVersion: networking.k8s.io/v1
  kind: NetworkPolicy
  metadata: { name: allow-n1-to-n2, namespace: netcheck }
  spec:
    podSelector: { matchLabels: { app: n2 } }
    policyTypes: [Ingress]
    ingress:
    - from:
      - podSelector: { matchLabels: { app: n1 } }
      ports: [{ protocol: TCP, port: 80 }]
  EOF

  # Succeeds now
  kubectl -n netcheck exec n1 -- curl -sS --max-time 3 http://n2

