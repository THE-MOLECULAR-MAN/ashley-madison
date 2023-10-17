#!/bin/bash
# Tim H 2023

CONTAINER_RUNTIME_NAME="ashley-madison5"

docker container start "$CONTAINER_RUNTIME_NAME"
docker exec -it "$CONTAINER_RUNTIME_NAME" bash
mysql aminno

