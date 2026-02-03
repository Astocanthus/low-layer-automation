# LOW-LAYER Platform Infrastructure Architecture

This document describes the **infrastructure architecture** of the LOW-LAYER platform.

---

## Overview

LOW-LAYER is a Platform Engineering as a Service (PEaaS) that provides isolated, production-ready infrastructure for startups and scaleups.

## Architecture Hierarchy

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        LOW-LAYER OpenStack Platform                         │
│                         (Auto-scaled via Kubernetes)                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌───────────────────────────────────────────────────────────────────────┐  │
│  │                     TENANT (Client A)                                 │  │
│  │                   Network Isolation Level                             │  │
│  │                                                                       │  │
│  │  ┌─────────────────────────────────────────────────────────────────┐  │  │
│  │  │                    ORGANISATION                                 │  │  │
│  │  │               (Mutualized or Dedicated)                         │  │  │
│  │  │                                                                 │  │  │
│  │  │  ┌─────────────────────┐    ┌─────────────────────────────────┐│  │  │
│  │  │  │  SERVICE BASTION    │    │         VPC ENVIRONMENTS        ││  │  │
│  │  │  │                     │    │                                 ││  │  │
│  │  │  │  ┌───────────────┐  │    │  ┌───────────┐  ┌───────────┐  ││  │  │
│  │  │  │  │   Keycloak    │  │◄──►│  │  VPC Dev  │  │ VPC Prod  │  ││  │  │
│  │  │  │  │    (IAM)      │  │    │  │           │  │           │  ││  │  │
│  │  │  │  └───────────────┘  │    │  │ ┌───────┐ │  │ ┌───────┐ │  ││  │  │
│  │  │  │                     │    │  │ │Workers│ │  │ │Workers│ │  ││  │  │
│  │  │  │  ┌───────────────┐  │    │  │ └───────┘ │  │ └───────┘ │  ││  │  │
│  │  │  │  │   OpenBao     │  │    │  │ ┌───────┐ │  │ ┌───────┐ │  ││  │  │
│  │  │  │  │  (Secrets)    │  │    │  │ │  Apps │ │  │ │  Apps │ │  ││  │  │
│  │  │  │  └───────────────┘  │    │  │ └───────┘ │  │ └───────┘ │  ││  │  │
│  │  │  │                     │    │  └───────────┘  └───────────┘  ││  │  │
│  │  │  │  ┌───────────────┐  │    │                                 ││  │  │
│  │  │  │  │ K8s Control   │  │    │         VPC Routing             ││  │  │
│  │  │  │  │    Plane      │  │────│                                 ││  │  │
│  │  │  │  └───────────────┘  │    │                                 ││  │  │
│  │  │  └─────────────────────┘    └─────────────────────────────────┘│  │  │
│  │  │                                                                 │  │  │
│  │  └─────────────────────────────────────────────────────────────────┘  │  │
│  │                                                                       │  │
│  │  (Can have multiple Organisations per Tenant)                         │  │
│  │                                                                       │  │
│  └───────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
│  ┌───────────────────────────────────────────────────────────────────────┐  │
│  │                     TENANT (Client B) ...                             │  │
│  └───────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Component Definitions

### 1. LOW-LAYER OpenStack Platform

- **Managed by**: LOW-LAYER
- **Scaling**: Auto-scaled via Kubernetes for rapid provisioning
- **Purpose**: Provides the underlying IaaS layer for all tenants

### 2. Tenant

- **Definition**: One tenant per client
- **Isolation**: Network-level isolation via OpenStack
- **Contents**: One or more Organisations

### 3. Organisation

- **Definition**: Logical grouping of infrastructure within a tenant
- **Resource Mode**: Can be **Mutualized** or **Dedicated**
- **Contents**:
  - One Service Bastion
  - One or more VPC Environments

### 4. Service Bastion

The central management plane for an Organisation. Contains:

| Service | Purpose |
|---------|---------|
| **Keycloak** | Identity & Access Management (SSO, MFA, Federation) |
| **OpenBao** | Secrets management (zero-trust) |
| **K8s Control Plane** | Manages Kubernetes clusters across VPC environments |

### 5. VPC Environments

Isolated network environments connected to the Bastion via VPC routing.

- **Examples**: Dev, Staging, Prod
- **Contents**:
  - Kubernetes Workers (nodes)
  - Application workloads
- **Resource Mode**: Each VPC can independently be Mutualized or Dedicated

## Resource Modes

### Mutualized (Cost-Saver)

- VMs share underlying hypervisor resources with other tenants
- **Overprovisioning**: Yes (resources not guaranteed at 100%)
- **Use case**: Development, testing, non-critical workloads
- **Cost**: Lower (€€)

### Dedicated (Performance)

- VMs have guaranteed resources on the hypervisor
- **Overprovisioning**: No (100% CPU/RAM guaranteed)
- **Use case**: Production, performance-critical workloads
- **Cost**: Higher (€€€)

> **Important**: This is NOT about physical hardware exclusivity. Both modes run on shared physical infrastructure. The difference is in VM-level resource allocation (overprovisioning vs guaranteed).

## Service Catalog

Services deployable on the platform:

| Category | Services |
|----------|----------|
| **Identity** | Keycloak, OpenBao |
| **Persistence** | PostgreSQL, MariaDB, Redis, ETCD, FerretDB |
| **Messaging** | RabbitMQ, Kafka, ActiveMQ |
| **Web & Mail** | Nginx, Ghost CMS, Mail Server |
| **Observability** | Prometheus, Grafana, Loki, Jaeger |
| **Storage** | Garage (S3-compatible), Rook Ceph |
| **Search & ETL** | OpenSearch, Meilisearch, Airflow, ClickHouse |
| **AI/ML** | Llama 3.1, Mistral Large, Kimi K2.5, DeepSeek (GPU clusters) |

## Target Audience

- **Startups**: Need production-ready infrastructure fast, without DevOps overhead
- **Scaleups**: Need to scale infrastructure while controlling costs
- **Tech Teams**: Want full control without cloud lock-in

## Key Architecture Principles

1. **Tenant Isolation**: Network-level isolation between clients at OpenStack level
2. **Flexible Resource Allocation**: Mix mutualized and dedicated resources per environment
3. **Centralized Services**: Keycloak, OpenBao, and K8s Control Plane in the Bastion
4. **VPC Routing**: All environments connected via routed VPCs
5. **No Lock-in**: Standard technologies (Kubernetes Vanilla, Terraform, OpenStack APIs)
6. **100% Open Source Stack**: All components are open source
