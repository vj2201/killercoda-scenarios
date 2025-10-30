Wrap-up

- Requirement recap:
  - Pod-to-pod connectivity
  - NetworkPolicy enforcement
  - Manifest-based installation

- Calico satisfies all three when installed via the operator manifest and Installation CR.
- Flannel installs via manifest but does not provide NetworkPolicy enforcement on its own.

Key verification:
- Calico pods running in `calico-system`
- A default-deny NetworkPolicy blocks traffic, and an allow policy restores it.

