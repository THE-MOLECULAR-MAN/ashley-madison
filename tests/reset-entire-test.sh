#!/bin/bash
# Tim H 2023

# reset the entire test:
docker container stop "$CONTAINER_RUNTIME_NAME"
docker container rm   "$CONTAINER_RUNTIME_NAME"
docker volume    rm   "$VOLUME_NAME"
