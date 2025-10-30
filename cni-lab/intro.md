Install a CNI via manifest that supports pod connectivity and NetworkPolicy enforcement.

Requirements:
- Pods can communicate with each other
- NetworkPolicy enforcement works
- Install from a manifest (no Helm)

Provided reference manifests (exam-style links):
- Flannel v0.26.1: https://github.com/flannel-io/flannel/releases/download/v0.26.1/kube-flannel.yml
- Calico v3.28.2 (operator): https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml

Task:
- Choose a CNI that satisfies the requirements and install it from the linked manifest(s).

Hint:
- Only one of the above enforces NetworkPolicy by itself.

