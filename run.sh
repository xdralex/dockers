#!/bin/bash

IMAGE=${1:-coreml:latest}

PORT=4004  # Jupyter port

exec docker run --rm -u apollo -p $PORT:8888 -v "$PWD/data:/home/apollo/data" jupyter-notebook --NotebookApp.ip=0.0.0.0 --NotebookApp.password_required=False --NotebookApp.token='' --NotebookApp.custom_display_url="http://localhost:$PORT"
