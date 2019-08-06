#!/bin/bash

docker run -u $(id -u):$(id -g) --rm coreml:latest uname
