Create a HorizontalPodAutoscaler named `apache-server` targeting 50% CPU with min 1 and max 4 replicas.

**Option 1: Imperative command (quickest for basic HPA)**

```bash
kubectl autoscale deployment apache-deployment \
  --name=apache-server \
  --cpu-percent=50 \
  --min=1 \
  --max=4 \
  -n autoscale
```

This creates a basic HPA but **doesn't include the downscale stabilization window**. You'll add that in Step 3.

**Option 2: Declarative YAML (without behavior policy)**

```bash
kubectl apply -f - <<'YAML'
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: apache-server
  namespace: autoscale
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: apache-deployment
  minReplicas: 1
  maxReplicas: 4
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
YAML
```

**Verify the HPA was created:**

`kubectl get hpa -n autoscale`

View HPA details:

`kubectl describe hpa apache-server -n autoscale`

Watch HPA status (press Ctrl+C to exit):

`kubectl get hpa apache-server -n autoscale --watch`

You should see output like:
```
NAME            REFERENCE                     TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
apache-server   Deployment/apache-deployment  0%/50%    1         4         1          30s
```

**Understanding the output:**
- `REFERENCE`: Which deployment to scale
- `TARGETS`: Current CPU% / Target CPU%
- `MINPODS/MAXPODS`: Scaling boundaries
- `REPLICAS`: Current number of pods
- `0%/50%`: Currently at 0% CPU, target is 50%

**Note:** The HPA is now created but without the downscale stabilization window. In the next step, you'll add the behavior policy to configure this.

**Why separate steps?**
- `kubectl autoscale` doesn't support behavior policies
- You must use YAML with `spec.behavior` for stabilization windows
- This mirrors real exam scenarios where you need to edit HPA after creation
