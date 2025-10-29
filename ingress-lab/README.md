# CKA Practice Lab — Expose Services with Ingress

This lab helps you practice exposing Kubernetes deployments using Services and Ingress - a common CKA exam topic.

## Scenario

An existing deployment named `echo-deployment` is running in the `echo-sound` namespace. Your task is to:

1. Expose the deployment with a NodePort Service named `echo-service` using port 8080
2. Create an Ingress resource named `echo` for http://example.org/echo
3. Verify the setup using curl commands

## Quick Start

**Killercoda (recommended):**
```
https://killercoda.com/vj2201/scenario/ingress-lab
```

**Local cluster:**
```bash
curl -s https://raw.githubusercontent.com/vj2201/killercoda-scenarios/main/ingress-lab/setup.sh | bash
```

Then follow the steps in the scenario.

## Learning Objectives

- Creating NodePort Services to expose deployments
- Understanding Service port vs targetPort
- Creating Ingress resources with host and path rules
- Using IngressClass to specify controllers
- Testing Ingress with curl and Host headers
- Troubleshooting Service and Ingress configurations

## Prerequisites

- Basic understanding of Kubernetes Services
- Familiarity with kubectl commands
- Knowledge of HTTP headers and curl

## Solution

See `solution/SOLUTION.md` for the complete solution and explanation.

## Related CKA Topics

- Services & Networking
- Ingress Controllers
- HTTP Routing
- Network Troubleshooting
