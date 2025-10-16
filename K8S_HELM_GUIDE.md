# 🎯 Kubernetes & Helm: A Practical Guide

## 📦 What is Kubernetes (K8s)?

**Kubernetes** is an open-source container orchestration platform that automates the deployment, scaling, and management of containerized applications.

### Core Concepts

#### 1. **Pod**
- The smallest deployable unit in Kubernetes
- Contains one or more containers that share resources
- Has its own IP address and storage volumes

```yaml
# Example: A simple Pod
apiVersion: v1
kind: Pod
metadata:
  name: my-app
spec:
  containers:
  - name: app-container
    image: my-app:1.0.0
    ports:
    - containerPort: 8080
```

#### 2. **Deployment**
- Manages a set of identical Pods
- Handles rolling updates and rollbacks
- Ensures desired number of Pods are running

```yaml
# Example: A Deployment with 3 replicas
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: app
        image: my-app:1.0.0
```

#### 3. **Service**
- Provides stable networking for Pods
- Load balances traffic across Pods
- Types: ClusterIP, NodePort, LoadBalancer

```yaml
# Example: A Service exposing Pods
apiVersion: v1
kind: Service
metadata:
  name: my-app-service
spec:
  type: ClusterIP
  selector:
    app: my-app
  ports:
  - port: 80
    targetPort: 8080
```

#### 4. **Namespace**
- Virtual clusters within a physical cluster
- Provides isolation and resource organization
- Default namespaces: `default`, `kube-system`, `kube-public`

### How Kubernetes Works

```
┌─────────────────────────────────────────────────────────┐
│                    Kubernetes Cluster                    │
│                                                          │
│  ┌────────────────────────────────────────────────┐    │
│  │              Control Plane                      │    │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐    │    │
│  │  │   API    │  │Scheduler │  │Controller│    │    │
│  │  │  Server  │  │          │  │ Manager  │    │    │
│  │  └──────────┘  └──────────┘  └──────────┘    │    │
│  └────────────────────────────────────────────────┘    │
│                                                          │
│  ┌────────────────────────────────────────────────┐    │
│  │                Worker Nodes                     │    │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐        │    │
│  │  │  Pod 1  │  │  Pod 2  │  │  Pod 3  │        │    │
│  │  │ ┌─────┐ │  │ ┌─────┐ │  │ ┌─────┐ │        │    │
│  │  │ │ App │ │  │ │ App │ │  │ │ App │ │        │    │
│  │  │ └─────┘ │  │ └─────┘ │  │ └─────┘ │        │    │
│  │  └─────────┘  └─────────┘  └─────────┘        │    │
│  └────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
```

## ⚓ What is Helm?

**Helm** is the package manager for Kubernetes. It simplifies the deployment and management of applications on Kubernetes clusters.

### Key Concepts

#### 1. **Chart**
- A package of pre-configured Kubernetes resources
- Contains templates, default values, and metadata
- Reusable and shareable

```
my-app-chart/
├── Chart.yaml          # Chart metadata
├── values.yaml         # Default configuration values
├── templates/          # Kubernetes manifest templates
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
└── charts/            # Dependency charts
```

#### 2. **Release**
- An instance of a chart running in a Kubernetes cluster
- Each installation creates a new release
- Can be upgraded, rolled back, or deleted

#### 3. **Repository**
- A collection of Helm charts
- Can be public (like Artifact Hub) or private
- Charts are versioned and stored here

### Helm Chart Structure

#### Chart.yaml
```yaml
apiVersion: v2
name: my-app
description: A Helm chart for my application
version: 1.0.0
appVersion: "1.0.0"
```

#### values.yaml
```yaml
replicaCount: 3

image:
  repository: my-app
  tag: "1.0.0"
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80
```

#### templates/deployment.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-deployment
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ .Chart.Name }}
  template:
    metadata:
      labels:
        app: {{ .Chart.Name }}
    spec:
      containers:
      - name: {{ .Chart.Name }}
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
        ports:
        - containerPort: 8080
```

## 🔗 How Kubernetes & Helm Work Together

### The Workflow

```
┌─────────────────────────────────────────────────────────┐
│                    Developer                             │
│                                                          │
│  1. Create Helm Chart                                   │
│     ├── Define templates                                │
│     ├── Set default values                              │
│     └── Package application                             │
└──────────────────┬──────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────┐
│                    Helm CLI                              │
│                                                          │
│  2. helm install my-release ./my-chart                  │
│     ├── Reads Chart.yaml                                │
│     ├── Merges values.yaml with custom values          │
│     └── Renders templates                               │
└──────────────────┬──────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────┐
│              Kubernetes API Server                       │
│                                                          │
│  3. Receives rendered manifests                         │
│     ├── Validates resources                             │
│     ├── Stores in etcd                                  │
│     └── Schedules Pods                                  │
└──────────────────┬──────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────┐
│              Kubernetes Cluster                          │
│                                                          │
│  4. Deploys application                                 │
│     ├── Creates Deployments                             │
│     ├── Starts Pods                                     │
│     ├── Configures Services                             │
│     └── Application is running!                         │
└─────────────────────────────────────────────────────────┘
```

### Benefits of Using Helm with Kubernetes

#### 1. **Simplified Deployment**
```bash
# Without Helm (manual)
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f configmap.yaml
kubectl apply -f ingress.yaml

# With Helm (one command)
helm install my-app ./my-app-chart
```

#### 2. **Configuration Management**
```bash
# Override default values
helm install my-app ./my-app-chart \
  --set replicaCount=5 \
  --set image.tag=2.0.0

# Or use a custom values file
helm install my-app ./my-app-chart -f production-values.yaml
```

#### 3. **Version Control & Rollbacks**
```bash
# Upgrade to new version
helm upgrade my-app ./my-app-chart --set image.tag=2.0.0

# Rollback if something goes wrong
helm rollback my-app 1

# View release history
helm history my-app
```

#### 4. **Templating & Reusability**
```yaml
# Single chart, multiple environments
# Development
helm install dev-app ./chart -f dev-values.yaml

# Staging
helm install staging-app ./chart -f staging-values.yaml

# Production
helm install prod-app ./chart -f prod-values.yaml
```

## 🎓 Practical Example: This Project

In this repository, we have three microservices, each with its own Helm chart:

```
helmk8s/
├── go-service-chart/
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
├── python-service-chart/
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
└── rust-service-chart/
    ├── Chart.yaml
    ├── values.yaml
    └── templates/
```

### Deployment Process

#### 1. **Build Docker Images**
```bash
cd go-service && make docker-build
cd python-service && make docker-build
cd rust-service && make docker-build
```

#### 2. **Load Images to Kind (Local K8s)**
```bash
kind load docker-image locally/go-service:1.0.0 --name kind
kind load docker-image locally/python-service:1.0.0 --name kind
kind load docker-image locally/rust-service:1.0.0 --name kind
```

#### 3. **Deploy with Helm**
```bash
# Deploy individual services
helm install go-release ./go-service-chart
helm install python-release ./python-service-chart
helm install rust-release ./rust-service-chart

# Or use an umbrella chart to deploy all at once
helm install system-v1 ./microservices-system-chart \
  --namespace microservices-ns \
  --create-namespace
```

#### 4. **Verify Deployment**
```bash
# Check releases
helm list -n microservices-ns

# Check Kubernetes resources
kubectl get pods -n microservices-ns
kubectl get services -n microservices-ns
```

## 🚀 Common Helm Commands

```bash
# Install a chart
helm install [RELEASE_NAME] [CHART]

# Upgrade a release
helm upgrade [RELEASE_NAME] [CHART]

# Rollback a release
helm rollback [RELEASE_NAME] [REVISION]

# Uninstall a release
helm uninstall [RELEASE_NAME]

# List all releases
helm list

# Get release status
helm status [RELEASE_NAME]

# View release history
helm history [RELEASE_NAME]

# Dry run (test without installing)
helm install [RELEASE_NAME] [CHART] --dry-run --debug

# Template rendering (see generated manifests)
helm template [RELEASE_NAME] [CHART]
```

## 🎯 Best Practices

### 1. **Use Values Files for Different Environments**
```yaml
# values-dev.yaml
replicaCount: 1
resources:
  limits:
    memory: "512Mi"

# values-prod.yaml
replicaCount: 3
resources:
  limits:
    memory: "2Gi"
```

### 2. **Version Your Charts**
```yaml
# Chart.yaml
version: 1.2.3  # Chart version
appVersion: "2.0.1"  # Application version
```

### 3. **Use Helm Hooks for Complex Deployments**
```yaml
# Pre-install job
apiVersion: batch/v1
kind: Job
metadata:
  annotations:
    "helm.sh/hook": pre-install
    "helm.sh/hook-weight": "0"
```

### 4. **Leverage Dependencies**
```yaml
# Chart.yaml
dependencies:
  - name: postgresql
    version: "12.1.0"
    repository: "https://charts.bitnami.com/bitnami"
```

## 🛠️ Essential Tools & Stacks for K8s & Helm

### 1. **Container Runtimes**

#### Docker
- Most popular container runtime
- Used for building and running containers
- Docker Desktop includes local Kubernetes

```bash
# Build container image
docker build -t my-app:1.0.0 .

# Run locally
docker run -p 8080:8080 my-app:1.0.0
```

#### containerd
- Industry-standard container runtime
- Used by most managed Kubernetes services
- Lightweight and efficient

### 2. **Local Kubernetes Development**

#### Kind (Kubernetes in Docker)
- Runs K8s clusters in Docker containers
- Fast and lightweight
- Perfect for CI/CD and local testing

```bash
# Create cluster
kind create cluster --name my-cluster

# Load local images
kind load docker-image my-app:1.0.0 --name my-cluster
```

#### Minikube
- Single-node Kubernetes cluster
- Supports multiple container runtimes
- Great for learning and development

```bash
# Start cluster
minikube start

# Enable addons
minikube addons enable ingress
minikube addons enable metrics-server
```

#### k3d
- Lightweight wrapper around k3s (Rancher's minimal K8s)
- Very fast startup
- Minimal resource usage

```bash
# Create cluster
k3d cluster create my-cluster

# Create with multiple nodes
k3d cluster create --agents 3
```

### 3. **Kubernetes Management Tools**

#### kubectl
- Official Kubernetes CLI
- Essential for cluster interaction
- Used for debugging and management

```bash
# Get resources
kubectl get pods -n my-namespace

# Describe resource
kubectl describe pod my-pod

# View logs
kubectl logs -f my-pod

# Execute commands in pod
kubectl exec -it my-pod -- /bin/bash
```

#### k9s
- Terminal-based UI for Kubernetes
- Interactive cluster management
- Real-time resource monitoring

```bash
# Launch k9s
k9s

# Navigate with keyboard shortcuts
# :pods, :svc, :deploy, etc.
```

#### Lens
- Kubernetes IDE (Desktop application)
- Visual cluster management
- Multi-cluster support
- Built-in terminal and metrics

#### Octant
- Web-based Kubernetes dashboard
- Real-time cluster visualization
- Plugin architecture

### 4. **CI/CD Tools**

#### ArgoCD
- GitOps continuous delivery tool
- Declarative deployments
- Automatic sync from Git repositories

```yaml
# ArgoCD Application
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-app
spec:
  source:
    repoURL: https://github.com/myorg/myrepo
    path: helm-charts/my-app
    targetRevision: main
  destination:
    server: https://kubernetes.default.svc
    namespace: production
```

#### Flux
- GitOps operator for Kubernetes
- Automated deployments from Git
- Helm integration

#### Jenkins X
- CI/CD solution for Kubernetes
- Automated pipelines
- Preview environments

#### Tekton
- Cloud-native CI/CD framework
- Kubernetes-native pipelines
- Reusable components

### 5. **Monitoring & Observability**

#### Prometheus
- Metrics collection and alerting
- Time-series database
- PromQL query language

```yaml
# Prometheus via Helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/prometheus
```

#### Grafana
- Metrics visualization
- Dashboards and alerts
- Multi-source support

```yaml
# Grafana via Helm
helm repo add grafana https://grafana.github.io/helm-charts
helm install grafana grafana/grafana
```

#### ELK Stack (Elasticsearch, Logstash, Kibana)
- Log aggregation and analysis
- Full-text search
- Log visualization

#### Loki + Promtail
- Lightweight log aggregation
- Integrates with Grafana
- Label-based indexing

```yaml
# Loki Stack via Helm
helm repo add grafana https://grafana.github.io/helm-charts
helm install loki grafana/loki-stack
```

#### Jaeger / Zipkin
- Distributed tracing
- Request flow visualization
- Performance analysis

### 6. **Service Mesh**

#### Istio
- Traffic management
- Security (mTLS)
- Observability
- Advanced routing

```bash
# Install Istio
istioctl install --set profile=demo

# Enable sidecar injection
kubectl label namespace default istio-injection=enabled
```

#### Linkerd
- Lightweight service mesh
- Automatic mTLS
- Simple to install and use

#### Consul
- Service mesh and service discovery
- Multi-cloud support
- Key-value store

### 7. **Ingress Controllers**

#### NGINX Ingress Controller
- Most popular ingress controller
- HTTP/HTTPS routing
- SSL termination

```yaml
# Install via Helm
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install nginx-ingress ingress-nginx/ingress-nginx
```

#### Traefik
- Modern HTTP reverse proxy
- Automatic service discovery
- Built-in Let's Encrypt support

#### Kong
- API Gateway
- Plugin ecosystem
- Rate limiting, authentication

### 8. **Security Tools**

#### Kyverno
- Kubernetes-native policy engine
- Validate, mutate, generate resources
- No new language to learn

```yaml
# Example policy
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-labels
spec:
  rules:
  - name: check-for-labels
    match:
      resources:
        kinds:
        - Pod
    validate:
      message: "Label 'app' is required"
      pattern:
        metadata:
          labels:
            app: "?*"
```

#### OPA (Open Policy Agent)
- General-purpose policy engine
- Rego policy language
- Fine-grained access control

#### Falco
- Runtime security monitoring
- Threat detection
- Behavioral monitoring

#### Trivy
- Container vulnerability scanner
- Scans images and IaC
- CI/CD integration

```bash
# Scan Docker image
trivy image my-app:1.0.0

# Scan Helm chart
trivy config ./my-chart
```

### 9. **Package Management & Templating**

#### Helmfile
- Declarative Helm chart management
- Manage multiple releases
- Environment-specific configurations

```yaml
# helmfile.yaml
releases:
  - name: go-service
    chart: ./go-service-chart
    values:
      - values-prod.yaml
  - name: python-service
    chart: ./python-service-chart
    values:
      - values-prod.yaml
```

#### Kustomize
- Template-free Kubernetes configuration
- Overlay-based customization
- Built into kubectl

```bash
# Apply with Kustomize
kubectl apply -k ./overlays/production
```

#### Skaffold
- Local Kubernetes development
- Continuous development workflow
- Auto-rebuild and redeploy

```yaml
# skaffold.yaml
apiVersion: skaffold/v2beta29
kind: Config
build:
  artifacts:
  - image: my-app
deploy:
  helm:
    releases:
    - name: my-app
      chartPath: ./chart
```

### 10. **Storage Solutions**

#### Rook
- Cloud-native storage orchestrator
- Ceph integration
- Persistent volumes

#### Longhorn
- Distributed block storage
- Backup and restore
- Simple to deploy

#### MinIO
- S3-compatible object storage
- Kubernetes-native
- High performance

### 11. **Secrets Management**

#### Sealed Secrets
- Encrypt secrets for Git
- Safe to commit
- Controller decrypts in cluster

```bash
# Create sealed secret
kubeseal --format yaml < secret.yaml > sealed-secret.yaml
```

#### External Secrets Operator
- Sync secrets from external sources
- AWS Secrets Manager, Vault, etc.
- Automatic rotation

#### HashiCorp Vault
- Secrets management platform
- Dynamic secrets
- Encryption as a service

### 12. **Cost Management**

#### Kubecost
- Cost monitoring and optimization
- Resource allocation tracking
- Multi-cluster support

#### OpenCost
- Open-source cost monitoring
- Real-time cost allocation
- Cloud provider integration

### 13. **Backup & Disaster Recovery**

#### Velero
- Backup and restore K8s resources
- Disaster recovery
- Cluster migration

```bash
# Install Velero
velero install --provider aws --bucket my-backup-bucket

# Create backup
velero backup create my-backup --include-namespaces production
```

## 🎯 Popular Tool Stacks

### Stack 1: **Development Stack**
```
Docker → Kind/Minikube → kubectl → k9s → Helm
```

### Stack 2: **Production Monitoring Stack**
```
Prometheus + Grafana + Loki + Jaeger
```

### Stack 3: **GitOps Stack**
```
Git → ArgoCD/Flux → Helm → Kubernetes
```

### Stack 4: **Security Stack**
```
Trivy → OPA/Kyverno → Falco → Vault
```

### Stack 5: **Complete Platform Stack**
```
Kubernetes
├── Ingress: NGINX/Traefik
├── Service Mesh: Istio/Linkerd
├── Monitoring: Prometheus + Grafana
├── Logging: Loki + Promtail
├── Tracing: Jaeger
├── CI/CD: ArgoCD
├── Security: OPA + Trivy
├── Secrets: Sealed Secrets
└── Backup: Velero
```

## 📚 Additional Resources

- **Kubernetes Docs**: <https://kubernetes.io/docs/>
- **Helm Docs**: <https://helm.sh/docs/>
- **Artifact Hub**: <https://artifacthub.io/> (Public Helm charts)
- **Kind**: <https://kind.sigs.k8s.io/> (Local Kubernetes clusters)
- **CNCF Landscape**: <https://landscape.cncf.io/> (Complete cloud-native ecosystem)

## 🎓 Summary

- **Kubernetes** orchestrates containers and manages application lifecycle
- **Helm** packages Kubernetes resources into reusable charts
- Together, they provide a powerful platform for deploying and managing cloud-native applications
- Helm simplifies complex Kubernetes deployments with templating and version control
- This project demonstrates real-world usage with three microservices deployed via Helm charts
- The ecosystem includes hundreds of tools for monitoring, security, CI/CD, and more
- Start simple and add tools as your needs grow

