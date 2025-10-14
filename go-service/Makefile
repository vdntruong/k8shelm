# Makefile for the go-service

# --- Variables ---
APP_NAME := go-service
# THAY THẾ bằng registry đúng hoặc ghi đè khi chạy: make REGISTRY=...
REGISTRY ?= locally
IMAGE_NAME := $(REGISTRY)/$(APP_NAME)
TAG ?= 1.0.0

HELM_CHART_PATH := ../go-service-chart
HELM_RELEASE_NAME := go-service-release

GO_VERSION := $(shell go version)

# --- Targets ---
.PHONY: all build run tidy docker-build docker-push helm-deploy helm-delete clean help

# Default Target for command `make`
default: help

help:
	@echo "Available commands for $(APP_NAME):"
	@echo "-----------------------------------------------------"
	@echo "  make build          : Build the Go binary locally."
	@echo "  make run            : Run the service locally (after building)."
	@echo "  make tidy           : Tidy Go module dependencies."
	@echo "  make docker-build   : Build the Docker image."
	@echo "  make docker-push    : Push the Docker image to the registry."
	@echo "  make helm-deploy    : Deploy or upgrade the application on Kubernetes using Helm."
	@echo "  make helm-delete    : Uninstall the application from Kubernetes."
	@echo "  make all            : Run docker-build, docker-push, and helm-deploy in sequence."
	@echo "  make clean          : Remove the local binary artifact."
	@echo "-----------------------------------------------------"
	@echo "Go version: $(GO_VERSION)"


# Build a Go binary
build:
	@echo "Building Go binary for $(APP_NAME)..."
	@go build -o $(APP_NAME) .

# Run the service locally
run: build
	@echo "Starting $(APP_NAME) locally..."
	@./$(APP_NAME)

# Tidy Go module dependencies
tidy:
	@echo "Tidying Go modules..."
	@go mod tidy

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
	@rm -f $(APP_NAME)
