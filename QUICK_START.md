# 🚀 Quick Start Guide

## Docker Compose (Recommended for Local Development)

### Start All Services

```bash
make up
```

### Test Services

```bash
make test-services
```

### View Logs

```bash
make logs
```

### Stop Services

```bash
make down
```

## Available Make Commands

| Command | Description |
|---------|-------------|
| `make up` | Start all services in detached mode |
| `make down` | Stop all services |
| `make build` | Build all Docker images |
| `make build-no-cache` | Build without cache |
| `make logs` | View all service logs |
| `make logs-go` | View Go service logs |
| `make logs-python` | View Python service logs |
| `make logs-rust` | View Rust service logs |
| `make ps` | Show running containers |
| `make restart` | Restart all services |
| `make clean` | Remove all containers, volumes, and images |
| `make test-services` | Test all service endpoints |

## Service URLs

- **Python Service**: <http://localhost:9081>
- **Go Service**: <http://localhost:9082>
- **Rust Service**: <http://localhost:9083>

## API Endpoints

All services support:

- `GET /` - Welcome message
- `GET /health` - Health check

## Full Documentation

- [Docker Compose Guide](./DOCKER_COMPOSE.md)
- [Main README](./README.md)
