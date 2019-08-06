NAME   := coreml
TAG    := $$(git log -1 --pretty=%h)
IMG    := ${NAME}:v0.0.1-${TAG}
LATEST := ${NAME}:latest

build:
	@docker build -t ${IMG} .
	@docker tag ${IMG} ${LATEST}

push:
	docker push xdralex/${IMG}
