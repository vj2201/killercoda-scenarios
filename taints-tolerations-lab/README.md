# Taints and Tolerations Lab

## Overview
This lab teaches you how to use Kubernetes taints and tolerations to control pod scheduling on specific nodes.

## Learning Objectives
- Add taints to nodes
- Configure tolerations in pod specifications
- Understand taint effects (NoSchedule, PreferNoSchedule, NoExecute)
- Use taints for node reservation strategies

## Scenario
Configure node01 with a taint to prevent normal pods from being scheduled, then create a pod with the appropriate toleration to bypass this restriction.

## Key Concepts
- **Taint**: A property applied to nodes that repels pods
- **Toleration**: A property in pod specs that allows scheduling on tainted nodes
- **Effect types**:
  - `NoSchedule`: Pods without toleration won't be scheduled
  - `PreferNoSchedule`: Soft version, avoid if possible
  - `NoExecute`: Evict running pods without toleration

## Time
15 minutes

## Difficulty
Intermediate
