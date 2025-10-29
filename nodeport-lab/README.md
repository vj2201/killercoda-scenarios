# NodePort Service Configuration Lab

**Difficulty:** Beginner-Intermediate
**Duration:** 10-15 minutes
**CKA Exam Topics:** Services & Networking

## Overview

This lab teaches you how to configure container ports in deployments and expose applications externally using NodePort Services. You'll learn the essential skills for making Kubernetes applications accessible from outside the cluster.

## Learning Objectives

By the end of this lab, you will be able to:

1. Configure containerPort in deployment specifications
2. Create and configure NodePort Services
3. Map service ports to container ports correctly
4. Use selectors to route traffic to the right pods
5. Verify service endpoints and test external access
6. Understand the differences between service types

## Prerequisites

- Basic understanding of Kubernetes pods and deployments
- Familiarity with kubectl commands
- Understanding of Kubernetes namespaces
- Basic knowledge of port mapping concepts

## Scenario

A deployment named `nodeport-deployment` exists in the `relative` namespace but isn't properly configured for external access. The deployment runs 2 nginx replicas but lacks the containerPort configuration.

Your tasks:
1. Configure the deployment to expose port 80 (with name=http, protocol=TCP)
2. Create a NodePort Service named `nodeport-service` exposing port 80 on NodePort 30080
3. Verify the service can route traffic to the pods

## Key Concepts Covered

- **containerPort**: Declares which port the container listens on
- **NodePort Service**: Exposes pods on a static port on each node
- **Port mapping**: Service port → container port → NodePort
- **Selectors**: How Services find pods to route traffic to
- **NodePort range**: 30000-32767 (default Kubernetes range)
- **Service types**: ClusterIP vs NodePort vs LoadBalancer

## Lab Structure

**Step 1: Configure Deployment containerPort**
- Verify existing deployment configuration
- Add containerPort specification using kubectl edit
- Wait for deployment rollout
- Verify the port configuration

**Step 2: Create NodePort Service**
- Create NodePort Service with specific NodePort value
- Configure selectors to match deployment pods
- Verify service endpoints
- Test external access via NodePort

## Files in This Lab

- `setup.sh` - Creates initial deployment without containerPort (runs in background)
- `foreground.sh` - Shows setup progress with timeout handling
- `preflight.sh` - Pre-flight checks before scenario starts
- `intro.md` - Lab introduction and scenario description
- `step1.md` - Instructions for configuring containerPort
- `step2.md` - Instructions for creating NodePort Service
- `finish.md` - Lab summary and key takeaways
- `solution/` - Complete solution files

## Solution Files

The `solution/` directory contains:
- `nodeport-deployment-with-port.yaml` - Deployment with containerPort configured
- `nodeport-service.yaml` - Complete NodePort Service definition
- `SOLUTION.md` - Step-by-step solution guide

## Testing Your Work

After completing the lab:

```bash
# Verify service exists
kubectl get svc -n relative

# Check service details and endpoints
kubectl describe svc nodeport-service -n relative

# Get node IP and test access
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
curl http://$NODE_IP:30080
```

You should see the nginx welcome page!

## Common Issues

**Issue: Service has no endpoints**
- Check that selector labels match deployment pod labels
- Verify pods are running: `kubectl get pods -n relative`

**Issue: Cannot access via NodePort**
- Verify NodePort is in valid range (30000-32767)
- Check firewall rules if running on cloud provider
- Ensure you're using the correct node IP

**Issue: containerPort changes not applied**
- Wait for deployment rollout: `kubectl rollout status deploy/nodeport-deployment -n relative`
- Check for deployment errors: `kubectl describe deploy nodeport-deployment -n relative`

## CKA Exam Tips

1. **Speed matters**: Use imperative commands when possible
   - `kubectl create service nodeport <name> --tcp=80:80 --node-port=30080`
   - Then edit to add selectors if needed

2. **Verify everything**: Always check your work
   - `kubectl get svc` - Verify service exists
   - `kubectl describe svc` - Check endpoints
   - `curl` - Test actual connectivity

3. **Know the YAML structure**: Be comfortable with both imperative and declarative approaches

4. **Remember the range**: NodePort must be 30000-32767 (default)

## Additional Resources

- [Kubernetes Services Documentation](https://kubernetes.io/docs/concepts/services-networking/service/)
- [Service Types](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)
- [kubectl create service](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_create/kubectl_create_service/)

## Author Notes

This lab is designed to simulate real CKA exam scenarios. The deployment is intentionally created without containerPort configuration to practice editing existing resources - a common exam task pattern.

---

**Part of the CKA Practice Lab Series**
For more labs, visit: https://github.com/vj2201/killercoda-scenarios
