# Docker Compose Commands
.PHONY: up down build logs ps restart clean test-services

up:
	docker compose up -d

down:
	docker compose down

build:
	docker compose build

build-no-cache:
	docker compose build --no-cache

logs:
	docker compose logs -f

logs-go:
	docker compose logs -f go-service

logs-python:
	docker compose logs -f python-service

logs-rust:
	docker compose logs -f rust-service

ps:
	docker compose ps

restart:
	docker compose restart

clean:
	docker compose down -v --rmi all

test-services:
	@echo "Testing Python Service (port 9081)..."
	@curl -s http://localhost:9081/health || echo "Python service not ready"
	@curl -s http://localhost:9081/ || echo "Python service not ready"
	@echo "\nTesting Go Service (port 9082)..."
	@curl -s http://localhost:9082/health || echo "Go service not ready"
	@curl -s http://localhost:9082/ || echo "Go service not ready"
	@echo "\nTesting Rust Service (port 9083)..."
	@curl -s http://localhost:9083/health || echo "Rust service not ready"
	@curl -s http://localhost:9083/ || echo "Rust service not ready"

# Kind Commands
kind-load-go:
	kind load docker-image locally/go-service:1.0.0 --name kind

kind-load-python:
	kind load docker-image locally/python-service:1.0.0 --name kind

kind-load-rust:
	kind load docker-image locally/rust-service:1.0.0 --name kind

# Helm Commands
deploy-helm-go:
	helm install go-release-1 ./go-service-chart

deploy-helm-python:
	helm install python-release-1 ./python-service-chart

deploy-helm-rust:
	helm install rust-release-1 ./rust-service-chart