NAME=pachyderm-demo-project
COMMIT_ID=$(shell git rev-parse HEAD)
WD="$(shell pwd)"

prerequisites:
	@which poetry > /dev/null || (echo "Poetry is not installed" && exit 1)
	@which docker > /dev/null || (echo "Docker is not installed" && exit 1)
	@which kubectl > /dev/null || (echo "Kubectl is not installed" && exit 1)
	@which minikube > /dev/null || (echo "Minikube is not installed" && exit 1)
	@which helm > /dev/null || (echo "Helm is not installed" && exit 1)
	@echo "All prerequisites are installed"

start-cluster:
	@minikube start --driver=docker

install:
	@helm repo add pachyderm https://helm.pachyderm.com
	@helm repo update
	@helm install pachyderm pachyderm/pachyderm --set deployTarget=LOCAL --set proxy.enabled=true --set proxy.service.type=LoadBalancer

status:
	@kubectl get pods

tunnel:
	@minikube tunnel

install-cli:
	@curl -o /tmp/pachctl.deb -L https://github.com/pachyderm/pachyderm/releases/download/v2.11.1/pachctl_2.11.1_amd64.deb && sudo dpkg -i /tmp/pachctl.deb

connect:
	@pachctl connect "http://$(shell kubectl get svc pachyderm-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}'):80"

verify:
	@pachctl version

fix-pre-commit:
	git config --local core.hooksPath .git/hooks

init: fix-pre-commit
	poetry install
	poetry run pre-commit run --all-files

check-all:
	poetry run pre-commit run --all-files

check:
	poetry run pre-commit

prepare_data:
	@poetry run python src/prepare_data.py
