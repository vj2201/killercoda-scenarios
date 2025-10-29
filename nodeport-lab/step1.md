Verify the deployment and configure it to expose port 80.

Check the deployment exists:

`kubectl get deploy -n relative`

View current deployment configuration:

`kubectl get deploy nodeport-deployment -n relative -o yaml | grep -A10 "containers:"`

Notice: No `containerPort` is defined.

**Edit the deployment to add containerPort:**

`kubectl edit deploy nodeport-deployment -n relative`

Add the `ports` section under the nginx container:

```yaml
spec:
  containers:
  - name: nginx
    image: nginx:1.24
    ports:
    - containerPort: 80
      name: http
      protocol: TCP
```

Save and exit. The deployment will automatically roll out.

Wait for rollout:

`kubectl rollout status deploy/nodeport-deployment -n relative`

Verify the containerPort is now configured:

`kubectl get deploy nodeport-deployment -n relative -o yaml | grep -A5 "ports:"`

You should see port 80 with name `http` and protocol `TCP`.

In the next step, you'll create the NodePort Service.
