# Network Policy Lab: Least Permissive Access

**Difficulty:** Intermediate
**Duration:** 10-15 minutes
**CKA Exam Topics:** Services & Networking

## Overview

Learn how to create least-permissive network policies to control pod-to-pod communication across namespaces.

## Scenario

Two deployments exist:
- **Frontend** in `frontend` namespace
- **Backend** in `backend` namespace

Create a network policy that allows Frontend to communicate with Backend while denying all other traffic.

## Tasks

Create a least-permissive network policy that:
1. Allows ingress to backend pods only from frontend namespace
2. Allows traffic only on port 8080
3. Denies all other traffic

## Key Concepts

- Network Policy basics
- Namespace selectors
- Pod selectors
- Least privilege principle
- Ingress rules
- Testing network policies

## Lab Structure

- `setup.sh` - Creates frontend and backend deployments
- `step1.md` - Create and verify network policy
- `solution/` - Complete solution

---

**Part of the CKA Practice Lab Series**
https://github.com/vj2201/killercoda-scenarios
