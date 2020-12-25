USER   	:= xdralex
NAME   	:= cuda
VERSION := core-11.1-cudnn8-devel
IMG    	:= ${USER}/${NAME}:${VERSION}

build:
	@docker build -t ${IMG} .

build-nocache:
	@docker build --no-cache -t ${IMG} .

push:
	docker push ${IMG}
