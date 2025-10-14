kind-load-go:
	kind load docker-image locally/go-service:1.0.0 --name kind

kind-load-python:
	kind load docker-image locally/python-service:1.0.0 --name kind

kind-load-rust:
	kind load docker-image locally/rust-service:1.0.0 --name kind

deploy-helm-go:
	helm install go-release-1 ./go-service-chart

deploy-helm-python:
	helm install python-release-1 ./python-service-chart

deploy-helm-rust:
	helm install rust-release-1 ./rust-service-chart