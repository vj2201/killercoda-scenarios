# Ingress to Gateway API Migration Lab

**Difficulty:** Intermediate-Advanced
**Duration:** 15-20 minutes
**CKA Exam Topics:** Services & Networking

## Overview

Migrate an existing Ingress configuration to the new Kubernetes Gateway API while maintaining HTTPS access.

## Scenario

An existing web application uses an Ingress resource named `web` for routing. You need to migrate to the Gateway API standard.

## Tasks

1. Create Gateway resource `web-gateway` with TLS configuration
2. Create HTTPRoute resource `web-route` with routing rules
3. Maintain hostname `gateway.web.k8s.local` and existing TLS setup

## Key Concepts

- Gateway API architecture
- GatewayClass, Gateway, HTTPRoute resources
- Ingress to Gateway migration
- TLS termination in Gateway API
- Role-oriented design

## Lab Structure

- `setup.sh` - Creates existing Ingress and Gateway API CRDs
- `step1.md` - Migration instructions
- `solution/` - Complete solution

---

**Part of the CKA Practice Lab Series**
https://github.com/vj2201/killercoda-scenarios
