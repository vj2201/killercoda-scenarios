Next, divide node resources evenly across 3 Pods and apply the same requests/limits to BOTH init and main containers.

1) Discover node allocatable resources (CPU, memory):

```
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name} {.status.allocatable.cpu} {.status.allocatable.memory}{"\n"}{end}'
```

Helpful parsing (optional):

```
# Example helper to compute per-pod requests from allocatable with 20% headroom (use bash on the node):
NODE=$(kubectl get node -o jsonpath='{.items[0].metadata.name}')
CPU=$(kubectl get node "$NODE" -o jsonpath='{.status.allocatable.cpu}')
MEM=$(kubectl get node "$NODE" -o jsonpath='{.status.allocatable.memory}')

# Convert CPU to millicores (handles values like 2 or 2000m)
if echo "$CPU" | grep -q m; then CPU_M=${CPU%m}; else CPU_M=$(echo "$CPU*1000" | bc); fi

# Convert memory to Mi (strip Ki/Mi/Gi etc). This is approximate; round conservatively.
UNIT=$(echo "$MEM" | sed -E 's/[0-9]//g')
VAL=$(echo "$MEM" | sed -E 's/[^0-9]//g')
case "$UNIT" in
  Ki) MEM_MI=$(echo "($VAL)/1024" | bc) ;;
  Mi) MEM_MI=$VAL ;;
  Gi) MEM_MI=$(echo "($VAL)*1024" | bc) ;;
  *)  MEM_MI=$VAL ;;
esac

# Keep ~20% headroom; divide the rest equally among 3 pods
BUDGET_CPU=$(echo "$CPU_M*0.8" | bc)
BUDGET_MEM=$(echo "$MEM_MI*0.8" | bc)

REQ_CPU_PER_POD=$(echo "$BUDGET_CPU/3" | bc)
REQ_MEM_PER_POD=$(echo "$BUDGET_MEM/3" | bc)

echo "Suggest per-pod requests: CPU=${REQ_CPU_PER_POD}m, MEM=${REQ_MEM_PER_POD}Mi"
```

2) Edit the Deployment and set identical resources on init and main containers. Keep requests equal across all Pods and leave overhead.

`kubectl edit deploy wordpress`

Within `spec.template.spec`, add matching `resources` to BOTH the init container and the main container. Example (replace values with your computed per-pod numbers):

```
    spec:
      initContainers:
      - name: init-setup
        image: busybox:stable
        command: ["/bin/sh", "-c"]
        args: ["echo init done; sleep 1"]
        resources:
          requests:
            cpu: "300m"      # example
            memory: "256Mi"  # example
          limits:
            cpu: "300m"
            memory: "256Mi"
      containers:
      - name: main-app
        image: busybox:stable
        command: ["/bin/sh", "-c"]
        args:
          - while true; do echo "WordPress app running..."; sleep 5; done
        resources:
          requests:
            cpu: "300m"
            memory: "256Mi"
          limits:
            cpu: "300m"
            memory: "256Mi"
```

Notes:
- Use the same requests/limits for init and main containers.
- Choose values so that 3 Pods together request about 80% (or similar) of node allocatable, leaving headroom to avoid instability.

