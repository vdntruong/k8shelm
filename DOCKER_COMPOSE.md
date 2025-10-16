# 🐳 Docker Compose Setup

This guide explains how to run all three microservices locally using Docker Compose.

## 🚀 Quick Start

### 1. Start All Services

```bash
docker-compose up -d
```

This will build and start all three services in detached mode.

### 2. View Logs

```bash
# View all services logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f go-service
docker-compose logs -f python-service
docker-compose logs -f rust-service
```

### 3. Check Service Health

```bash
# Python Service (port 9081)
curl http://localhost:9081/health
curl http://localhost:9081/

# Go Service (port 9082)
curl http://localhost:9082/health
curl http://localhost:9082/

# Rust Service (port 9083)
curl http://localhost:9083/health
curl http://localhost:9083/
```

## 📊 Service Ports

| Service | Internal Port | External Port | URL |
|---------|---------------|---------------|-----|
| **Python Service** | 8000 | 9081 | <http://localhost:9081> |
| **Go Service** | 8080 | 9082 | <http://localhost:9082> |
| **Rust Service** | 8080 | 9083 | <http://localhost:9083> |

> **Note:** External ports are mapped to 9081 (Python), 9082 (Go), and 9083 (Rust) to avoid conflicts with other services.

## 🛠️ Common Commands

### Build Services

```bash
# Build all services
docker-compose build

# Build specific service
docker-compose build go-service
docker-compose build python-service
docker-compose build rust-service

# Build without cache
docker-compose build --no-cache
```

### Start/Stop Services

```bash
# Start all services
docker-compose up -d

# Start specific service
docker-compose up -d go-service

# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

### Service Management

```bash
# Restart all services
docker-compose restart

# Restart specific service
docker-compose restart python-service

# View running containers
docker-compose ps

# View service status
docker-compose ps -a
```

### Debugging

```bash
# Execute command in running container
docker-compose exec go-service sh
docker-compose exec python-service bash
docker-compose exec rust-service sh

# View container stats
docker stats
```

## 🔍 Health Checks

All services include health checks that run every 30 seconds:

- **Test:** HTTP GET to `/health` endpoint
- **Interval:** 30 seconds
- **Timeout:** 10 seconds
- **Retries:** 3
- **Start Period:** 10 seconds

View health status:

```bash
docker-compose ps
```

## 🌐 Network

All services are connected to a custom bridge network called `microservices-network`, allowing them to communicate with each other using service names:

- `http://go-service:8080`
- `http://python-service:8000`
- `http://rust-service:8080`

## 🧹 Cleanup

```bash
# Stop and remove containers, networks
docker-compose down

# Remove everything including images
docker-compose down --rmi all

# Remove everything including volumes
docker-compose down -v --rmi all
```

## 🔧 Troubleshooting

### Port Already in Use

If you get a port conflict error:

1. Check what's using the port:

   ```bash
   lsof -i :8080
   lsof -i :8000
   lsof -i :8081
   ```

2. Stop the conflicting process or modify ports in `docker-compose.yml`

### Service Won't Start

1. Check logs:

   ```bash
   docker-compose logs [service-name]
   ```

2. Rebuild the service:

   ```bash
   docker-compose build --no-cache [service-name]
   docker-compose up -d [service-name]
   ```

### Container Keeps Restarting

1. Check health check status:

   ```bash
   docker-compose ps
   ```

2. Inspect container:

   ```bash
   docker inspect [container-name]
   ```

## 📝 Development Workflow

For active development with hot reload:

1. **Python Service** (FastAPI with auto-reload):

   ```bash
   # Already configured with reload=True in main.py
   docker-compose up python-service
   ```

2. **Go/Rust Services**:
   - Stop the container
   - Make code changes
   - Rebuild and restart:

     ```bash
     docker-compose up -d --build go-service
     docker-compose up -d --build rust-service
     ```

## 🎯 Testing All Services

Quick test script:

```bash
#!/bin/bash

echo "Testing Python Service..."
curl -s http://localhost:9081/health | jq
curl -s http://localhost:9081/ | jq

echo -e "\nTesting Go Service..."
curl -s http://localhost:9082/health | jq
curl -s http://localhost:9082/ | jq

echo -e "\nTesting Rust Service..."
curl -s http://localhost:9083/health | jq
curl -s http://localhost:9083/ | jq
```

Save as `test-services.sh`, make executable with `chmod +x test-services.sh`, and run `./test-services.sh`.
