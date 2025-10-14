# python-service/Makefile

# --- Variables ---
APP_NAME := python-service
REGISTRY ?= locally
IMAGE_NAME := $(REGISTRY)/$(APP_NAME)
TAG ?= 1.0.0

HELM_CHART_PATH := ../python-service-chart
HELM_RELEASE_NAME := py-service-release

# --- Targets ---
.PHONY: all build run docker-build docker-push helm-deploy helm-delete clean help deps

default: help

help:
	@echo "Available commands for $(APP_NAME):"
	@echo "-----------------------------------------------------"
	@echo "  make deps           : Install local Python dependencies (for local development)."
	@echo "  make run            : Run the service locally."
	@echo "  make docker-build   : Build the Docker image."
	@echo "  make docker-push    : Push the Docker image to the registry."
	@echo "  make helm-deploy    : Deploy or upgrade the application on Kubernetes using Helm."
	@echo "  make helm-delete    : Uninstall the application from Kubernetes."
	@echo "  make all            : Run docker-build, docker-push, and helm-deploy in sequence."
	@echo "  make clean          : Remove temporary files."
	@echo "-----------------------------------------------------"

# Install local Python dependencies
deps:
	@echo "Installing Python dependencies locally..."
	@pip install -r requirements.txt

# Run the service locally
run: deps
	@echo "Starting $(APP_NAME) locally on port 8000..."
	@python main.py

# Build a Docker image
docker-build:
	@echo "Building Docker image: $(IMAGE_NAME):$(TAG)..."
	@docker build -t $(IMAGE_NAME):$(TAG) .

# Push the Docker image to a registry
docker-push:
	@echo "Pushing Docker image: $(IMAGE_NAME):$(TAG)..."
	@docker push $(IMAGE_NAME):$(TAG)

# Deploy using Helm
helm-deploy:
	@echo "Deploying/Upgrading Helm release '$(HELM_RELEASE_NAME)'..."
	@helm upgrade --install $(HELM_RELEASE_NAME) $(HELM_CHART_PATH) \
		--set image.repository=$(IMAGE_NAME) \
		--set image.tag=$(TAG) \
		--set service.port=80 \
		--namespace default \
		--create-namespace

# Delete a Helm release
helm-delete:
	@echo "Deleting Helm release '$(HELM_RELEASE_NAME)'..."
	@helm uninstall $(HELM_RELEASE_NAME)

# A target to do everything
all: docker-build docker-push helm-deploy

# Clean up
clean:
	@echo "Cleaning up..."
	@rm -rf __pycache__ .pytest_cache .venv
