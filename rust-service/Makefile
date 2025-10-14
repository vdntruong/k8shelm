# --- Variables ---
APP_NAME := rust-service
REGISTRY ?= locally
IMAGE_NAME := $(REGISTRY)/$(APP_NAME)
TAG ?= 1.0.0

HELM_CHART_PATH := ../rust-service-chart
HELM_RELEASE_NAME := rust-service-release

# --- Targets ---
.PHONY: all build run docker-build docker-push helm-deploy helm-delete clean help

default: help

help:
	@echo "Available commands for $(APP_NAME):"
	@echo "-----------------------------------------------------"
	@echo "  make build          : Build the Rust binary locally (release mode)."
	@echo "  make run            : Run the service locally."
	@echo "  make docker-build   : Build the Docker image."
	@echo "  make docker-push    : Push the Docker image to the registry."
	@echo "  make helm-deploy    : Deploy or upgrade the application on Kubernetes using Helm."
	@echo "  make helm-delete    : Uninstall the application from Kubernetes."
	@echo "  make all            : Run docker-build, docker-push, and helm-deploy in sequence."
	@echo "  make clean          : Remove build artifacts."
	@echo "-----------------------------------------------------"

# Build the Rust binary (Release mode)
build:
	@echo "Building Rust binary for $(APP_NAME) in Release mode..."
	@cargo build --release

# Run the service locally
run: build
	@echo "Starting $(APP_NAME) locally on port 8080..."
	@./target/release/$(APP_NAME)

# Build a Docker image
docker-build:
	@echo "Building Docker image: $(IMAGE_NAME):$(TAG)..."
	@docker build --platform linux/amd64 -t $(IMAGE_NAME):$(TAG) .

# Push the Docker image to a registry
docker-push:
	@echo "Pushing Docker image: $(IMAGE_NAME):$(TAG)..."
	@docker push $(IMAGE_NAME):$(TAG)

# Deploy using Helm (Cần tạo chart trước)
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

# Clean up build artifacts
clean:
	@echo "Cleaning up..."
	@cargo clean
