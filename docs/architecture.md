# Phoenix TaskApp — Architecture

## 1. Project Overview

Phoenix TaskApp is a production-style deployment of a task management application on a self-provisioned Kubernetes cluster.

The project migrates the application from a traditional single-server deployment to a multi-node Kubernetes architecture with infrastructure automation, persistent storage, HTTPS, autoscaling, disruption protection, and GitOps.

## 2. Architecture


                         Internet
                            |
                            v
                  DuckDNS Domain
            abdulsalam-taskapp.duckdns.org
                            |
                            v
                  Let's Encrypt TLS
                    cert-manager
                            |
                            v
                    Traefik Ingress
                     /           \
                    /             \
                   v               v
              Frontend          Backend
              2 replicas        2 replicas
                   |                |
                   |                |
                   +------ /api ----+
                                    |
                                    v
                              PostgreSQL
                              StatefulSet
                                    |
                                    v
                              10Gi PVC
                           Persistent Storage


                 AWS / us-east-2
                       |
              +--------+--------+
              |                 |
        K3s Control Plane    Workers
        10.0.1.79            10.0.2.51
                            10.0.3.200
              |
              +------ Kubernetes Cluster
3. Infrastructure

AWS infrastructure is provisioned using Terraform.

The environment contains:

1 VPC using 10.0.0.0/16
3 public subnets across multiple Availability Zones
1 K3s control-plane node
2 K3s worker nodes
Internet Gateway
Security Group
S3 remote Terraform state
Native S3 state locking

Terraform is organized into reusable modules:
infra/
└── terraform/
    ├── network/
    ├── security_group/
    ├── compute/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── backend.tf
4. Network Security

The AWS Security Group follows least-privilege principles.

Publicly accessible ports:

TCP 80 — HTTP
TCP 443 — HTTPS

SSH:

TCP 22 is restricted to the administrator's current public IP.

Kubernetes internal traffic:

TCP 6443 — K3s API, restricted to the Kubernetes security group
UDP 8472 — Flannel VXLAN, restricted to the Kubernetes security group
TCP 10250 — Kubelet, restricted to the Kubernetes security group

The Kubernetes API is therefore not publicly exposed on port 6443.

5. Configuration Management

Ansible is used to configure the Kubernetes nodes.

Roles include:

Base system hardening
K3s server installation
K3s agent installation

The K3s agents join the control plane using the private VPC address.

Sensitive information such as the K3s node token and kubeconfig is excluded from Git.

6. Kubernetes

The cluster uses K3s.

Current cluster:

Kubernetes version: v1.36.4+k3s1
1 control-plane node
2 worker nodes

All nodes are currently healthy and report Ready.

The application runs inside a dedicated namespace:
taskapp
7. Application Components
Frontend

The frontend is deployed as a Kubernetes Deployment with:

2 replicas
Immutable container image digest
Non-root execution
CPU and memory requests/limits
Startup probe
Liveness probe
Readiness probe
Topology spread constraints
Backend

The backend is deployed as a Kubernetes Deployment with:

2 replicas
Immutable container image digest
Non-root execution
CPU and memory requests/limits
Startup probe
Liveness probe
Readiness probe
Graceful termination
RollingUpdate strategy
maxUnavailable: 0
Topology spread constraints

The backend replicas are distributed across different Kubernetes nodes.

8. Database

PostgreSQL runs as a StatefulSet.

The database uses:

PersistentVolumeClaim
10Gi persistent storage
local-path StorageClass
Dedicated PostgreSQL service
Kubernetes Secret for database credentials

Database migrations are performed using a Kubernetes Job rather than running migrations from the application entrypoint.

This prevents multiple backend replicas from attempting to perform database migrations simultaneously.

9. Persistence Verification

Database persistence was tested by:

Creating a temporary test record.
Confirming the record existed.
Deleting the PostgreSQL pod.
Allowing Kubernetes to recreate the pod.
Confirming the record remained after recreation.
Removing the temporary test record.

This demonstrated that application data survives PostgreSQL pod recreation.

10. Health Checks

The application uses Kubernetes health probes.

Backend:

/api/health
/api/ready

Frontend:

/healthz

PostgreSQL readiness is checked using:

pg_isready

Startup, readiness, and liveness probes allow Kubernetes to distinguish between starting, ready, and unhealthy containers.

11. High Availability

The frontend and backend each run multiple replicas.

Topology spread constraints distribute replicas across different nodes.

This reduces the impact of losing a single worker node.

The backend also uses a PodDisruptionBudget:

minAvailable: 1

This protects against voluntary disruptions removing all backend replicas simultaneously.

12. Autoscaling

The backend uses a Kubernetes Horizontal Pod Autoscaler.

Configuration:

Minimum replicas: 2
Maximum replicas: 5
CPU target: 70%

Scale-up is intentionally faster than scale-down.

Scale-down has a stabilization period to reduce unnecessary replica fluctuations.

13. Container Security

Application containers use security hardening including:

Non-root users
allowPrivilegeEscalation: false
Linux capabilities dropped
RuntimeDefault seccomp profile
Immutable image digests

Container images are not deployed using the latest tag.

14. HTTPS

The application is available through:

https://abdulsalam-taskapp.duckdns.org

Traefik provides ingress routing.

cert-manager automatically obtains and manages the TLS certificate from Let's Encrypt.

Traffic routing:

/api/*  -> backend service
/*      -> frontend service

This provides a same-origin architecture for the application.

15. GitOps

Argo CD is used to manage the application deployment.

The Git repository is the source of truth.

Argo CD monitors:

https://github.com/momoduabdulsalam/taskapp.git

The Kubernetes manifests are stored under:

manifests/

Argo CD is configured for:

Automated synchronization
Self-healing
Pruning
Server-side apply

Deployment ordering is controlled using Argo CD sync waves:

PostgreSQL
    ↓
Migration
    ↓
Backend
    ↓
Frontend

The initial Argo CD Application bootstrap was performed manually, after which Argo CD manages the application state.

16. Secrets Management

Sensitive credentials are not committed to Git.

The following are excluded from version control:

Database passwords
Application secret keys
K3s node token
Kubernetes kubeconfig

Application secrets are stored as Kubernetes Secrets.

17. Repository Structure
taskapp/
├── backend/
├── src/
├── manifests/
├── gitops/
├── infra/
│   ├── terraform/
│   └── ansible/
├── docs/
├── Dockerfile
├── package.json
└── README.md
18. Deployment Flow

The overall deployment process is:

Developer
    |
    v
GitHub Repository
    |
    +--> Terraform --> AWS Infrastructure
    |
    +--> Ansible --> K3s Cluster
    |
    +--> Container Images --> GHCR
    |
    +--> Argo CD --> Kubernetes
                         |
                         +--> PostgreSQL
                         +--> Migration
                         +--> Backend
                         +--> Frontend
                         +--> Ingress
19. Reliability Features

The deployment includes several reliability mechanisms:

Multiple application replicas
Pod distribution across nodes
Persistent database storage
Database migration Job
Startup/readiness/liveness probes
Rolling updates
maxUnavailable: 0
Horizontal Pod Autoscaling
PodDisruptionBudget
Graceful termination
HTTPS
GitOps self-healing
20. Current Cluster Status

The Kubernetes cluster currently contains:

1 healthy control-plane node
2 healthy worker nodes
2 backend replicas
2 frontend replicas
1 PostgreSQL StatefulSet pod
Persistent PostgreSQL storage
Working HTTPS ingress
Working Argo CD deployment management
