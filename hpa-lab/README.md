# CKA Practice Lab — HorizontalPodAutoscaler with Behavior Policies

This lab helps you practice creating and configuring HorizontalPodAutoscaler (HPA) with custom scaling behavior - an important CKA exam topic.

## Scenario

An Apache deployment named `apache-deployment` is running in the `autoscale` namespace. Your tasks are to:

1. Create a HorizontalPodAutoscaler named `apache-server`
2. Target the apache-deployment for 50% CPU utilization
3. Set minimum 1 pod and maximum 4 pods
4. Configure downscale stabilization window to 30 seconds

## Quick Start

**Killercoda (recommended):**
```
https://killercoda.com/vj2201/scenario/hpa-lab
```

**Local cluster:**
```bash
curl -s https://raw.githubusercontent.com/vj2201/killercoda-scenarios/main/hpa-lab/setup.sh | bash
```

Then follow the steps in the scenario.

## Learning Objectives

- Understanding HorizontalPodAutoscaler (HPA) concepts
- Creating HPA with CPU percentage targets
- Configuring min/max replica boundaries
- Using behavior policies for custom scaling
- Setting stabilization windows to prevent flapping
- Working with metrics-server
- Understanding autoscaling/v2 API

## Prerequisites

- Basic kubectl knowledge
- Understanding of Deployments and resource requests
- Familiarity with CPU/memory metrics

## Solution

See `solution/SOLUTION.md` for the complete solution and explanation.

## Related CKA Topics

- Autoscaling
- Resource Management
- Metrics Server
- HPA Behavior Policies
- Performance Tuning
