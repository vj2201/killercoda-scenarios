You will create a HorizontalPodAutoscaler (HPA) with custom scaling behavior.

**Scenario:**
An Apache deployment named `apache-deployment` is running in the `autoscale` namespace. You need to configure autoscaling based on CPU usage with specific scaling parameters.

**Tasks:**
1. Create a new HorizontalPodAutoscaler named `apache-server` in the autoscale namespace
2. Target the existing deployment `apache-deployment`
3. Set the HPA to target 50% CPU usage per Pod
4. Configure minimum 1 pod and maximum 4 pods
5. Set the downscale stabilization window to 30 seconds

**Key Concepts:**
- **HPA** automatically scales the number of pods based on metrics
- **CPU target** defines when to scale up or down
- **Min/Max replicas** set boundaries for scaling
- **Stabilization window** prevents flapping during downscaling
- **Metrics-server** provides CPU/memory metrics to HPA

**How HPA works:**
- Monitors resource metrics (CPU, memory) or custom metrics
- Compares current vs target utilization
- Scales pods up/down to meet target
- Uses stabilization windows to prevent rapid scaling changes

The setup script has already:
- Created the `autoscale` namespace
- Deployed `apache-deployment` with resource requests
- Installed metrics-server (required for HPA)
