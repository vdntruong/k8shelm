# 🚀 Microservices System Starter Kit (Go, Python, Rust)

This project is a **sample microservices system** demonstrating best practices for building, containerizing, and deploying multi-language applications to **Kubernetes (K8s)** using a comprehensive **Helm Chart**.

---

## 💡 Project Overview

The system comprises three distinct microservices, showcasing production readiness across different technology stacks.

| Service | Technology | Base Port | Key Focus |
| :--- | :--- | :--- | :--- |
| **`go-service`** | Go (Functions Framework) | `8080` | High performance, minimal resource footprint. |
| **`python-service`** | Python (FastAPI) | `8000` | Rapid development, modern ASGI server. |
| **`rust-service`** | Rust (Axum) | `8080` | Safety, speed, and exceptional efficiency. |

### API Contract

All services adhere to a uniform API contract:

* **`GET /`**: Returns a JSON welcome message.
* **`GET /health`**: Returns a JSON status check (`{"status": "ok"}`) for K8s Probes.

---

## 🛠️ Prerequisites

Ensure you have the following tools installed locally:

* **Containerization:** Docker
* **Build Tools:** Go, Python 3.11+, Rust & Cargo, and **Make**
* **Orchestration:** **Minikube** or **Kind** (local K8s cluster)
* **Deployment:** `kubectl` and **Helm 3+**

---

## 📦 Local Setup and Deployment

This workflow uses **Kind** for local deployment. Images are built and loaded directly into the cluster, avoiding an external registry.

### 1. Build & Load Images

Images must be built and loaded into your local K8s cluster (assuming Kind is running).

| Step | Command | Description |
| :--- | :--- | :--- |
| **Go** | `cd go-service && make docker-build` | Builds `locally/go-service:1.0.0` |
| **Load Go** | `kind load docker-image locally/go-service:1.0.0 --name kind` | Transfers image to Kind's internal Docker daemon. |
| **Python** | `cd python-service && make docker-build` | Builds `locally/python-service:1.0.0` |
| **Load Python**| `kind load docker-image locally/python-service:1.0.0 --name kind` | Transfers image to Kind's internal Docker daemon. |
| **Rust** | `cd rust-service && make docker-build` | Builds `locally/rust-service:1.0.0` |
| **Load Rust**| `kind load docker-image locally/rust-service:1.0.0 --name kind` | Transfers image to Kind's internal Docker daemon. |

### 2. Install the System

The deployment uses the **Umbrella Helm Chart** located in `./microservices-system-chart`. This chart includes all three services as dependencies.

> **Crucial Setting:** The chart is pre-configured with `imagePullPolicy: Never` for local testing.

```bash
# Install the entire system in a new namespace
helm install system-v1 ./microservices-system-chart \
  --namespace microservices-ns \
  --create-namespace

# Verify Pod status (they should transition to 'Running')
kubectl get pods -n microservices-ns
```

## 🔬 Testing and Access

Since services use ClusterIP, we use kubectl port-forward to create a tunnel from your host machine to a Pod inside the cluster.

Example: Testing the Python Service

1. Get Pod Name: Find the name of one of the Python Pods.

```bash
PYTHON_POD=$(kubectl get pods -n microservices-ns -l app.kubernetes.io/name=python-service-chart -o jsonpath='{.items[0].metadata.name}')
```

2. Start Port Forwarding: (Keep this terminal open)

```bash
# Forward local port 8000 to the container's port 8000
kubectl port-forward $PYTHON_POD 8000:8000 -n microservices-ns
```

3. Test API (New Terminal):

```bash
curl http://localhost:8000/health
# Expected: {"status":"ok"}
```

## 🗑️ Cleanup

To remove the entire deployed system and its associated resources:

```bash
helm uninstall system-v1 --namespace microservices-ns
kubectl delete namespace microservices-ns
```