USER   := xdralex
NAME   := coreml
TAG    := $$(git log -1 --pretty=%h)
IMG    := ${USER}/${NAME}:v0.0.1-${TAG}
LATEST := ${USER}/${NAME}:latest

build:
	@docker build -t ${IMG} .
	@docker tag ${IMG} ${LATEST}

push:
	docker push ${IMG}
