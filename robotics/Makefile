USER   := xdralex
NAME   := robotics
TAG    := $$(git log -1 --pretty=%h)
IMG    := ${USER}/${NAME}:v0.0.3-${TAG}
LATEST := ${USER}/${NAME}:latest

build:
	@docker build -t ${IMG} .
	@docker tag ${IMG} ${LATEST}

build-nocache:
	@docker build --no-cache -t ${IMG} .
	@docker tag ${IMG} ${LATEST}

push:
	docker push ${IMG}
