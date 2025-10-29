# TLS Configuration with ConfigMap Lab

**Difficulty:** Intermediate
**Duration:** 10-15 minutes
**CKA Exam Topics:** Configuration, Services & Networking

## Overview

Configure nginx to enforce TLSv1.3 only by editing a ConfigMap, then verify the configuration using curl.

## Scenario

An nginx deployment in the `nginx-static` namespace is configured with a ConfigMap that currently supports both TLSv1.2 and TLSv1.3. You need to restrict it to only TLSv1.3.

## Tasks

1. Edit the ConfigMap to only support TLSv1.3
2. Add the service IP to `/etc/hosts` as `ckaquestion.k8s.local`
3. Verify TLSv1.2 fails and TLSv1.3 works

## Key Concepts

- ConfigMap configuration
- nginx TLS settings
- Deployment restart after config changes
- /etc/hosts DNS resolution
- TLS version testing with curl

## Files

- `setup.sh` - Creates nginx deployment with TLS
- `step1.md` - Configure TLS version
- `step2.md` - Add /etc/hosts and verify
- `solution/` - Complete solution

## Quick Start

Visit the lab on Killercoda or run locally with the provided setup script.

---

**Part of the CKA Practice Lab Series**
https://github.com/vj2201/killercoda-scenarios
