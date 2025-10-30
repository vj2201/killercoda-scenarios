Goal: Install a CNI via manifest that enables pod-to-pod networking and enforces NetworkPolicy.

Options (pick one):
- Flannel v0.26.1: https://github.com/flannel-io/flannel/releases/download/v0.26.1/kube-flannel.yml
- Calico v3.28.2 (operator): https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml

Task (recommended Calico):
1) Install the Calico operator:
   kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml

2) Create the Installation (manifest install, VXLAN pod CIDR example):
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

3) (Optional) Enable Calico API server (useful for some clusters):
   cat <<'EOF' | kubectl apply -f -
   apiVersion: operator.tigera.io/v1
   kind: APIServer
   metadata:
     name: default
   EOF

4) Wait and verify:
   kubectl -n tigera-operator get pods
   kubectl -n calico-system get pods

Validation (policy enforcement):
- Apply a quick default-deny and confirm traffic is blocked until allowed:
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

- Test from n1 (should fail due to default-deny):
  kubectl -n netcheck exec n1 -- curl -sS --max-time 3 http://n2

- Allow n1 -> n2 on TCP/80:
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

- Re-test (should succeed):
  kubectl -n netcheck exec n1 -- curl -sS --max-time 3 http://n2

Notes:
- If your cluster uses a specific pod CIDR, adjust the Installation ipPools cidr.
- Flannel installs via manifest but does not implement NetworkPolicy itself.

