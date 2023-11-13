#!/bin/bash
# Tim H 2023

# backup of mysql's db volume files, not an SQL dump
# https://stackoverflow.com/questions/26331651/how-can-i-backup-a-docker-container-with-its-data-volumes

# set -e

CONTAINER_RUNTIME_NAME="ubuntu-backup-test1"
ORIGINAL_VOLUME_NAME="db_test1"
ORIGINAL_VOLUME_MOUNT_POINT="/var/lib/mysql"
TEMPORARY_CONTAINER_NAME="tmp_backup"
# works on both mac and linux:
NOW=$(date +"%Y_%m_%d_%I_%M_%p_%z")
NEW_BACKUP_VOLUME_NAME="volume-backup-$ORIGINAL_VOLUME_NAME-$NOW"

# retest:
docker container stop "$CONTAINER_RUNTIME_NAME"
docker container rm   "$CONTAINER_RUNTIME_NAME"

# create the container and attach the volume
# write some random data to the volume - 1 MB worth
docker run \
    --mount source="$ORIGINAL_VOLUME_NAME",target="$ORIGINAL_VOLUME_MOUNT_POINT" \
    --name "$CONTAINER_RUNTIME_NAME" \
    ubuntu \
    dd if=/dev/zero of="$ORIGINAL_VOLUME_MOUNT_POINT/random_file" bs=1024 count=1024

# stop the original container
# simulates stopping the MySQL container so that no changes are made
# to the contents of the volume
docker container stop "$CONTAINER_RUNTIME_NAME"

docker container rm "$TEMPORARY_CONTAINER_NAME" || echo "tmp container didn't exist"

# create a temporary docker container that:
#   1) mounts the volume(s) from the original container
#   2) creates a NEW volume and mounts it to /backup
#   3) creates a tar backup of the original files to the new one.

docker run \
    --mount source="$ORIGINAL_VOLUME_NAME",target="$ORIGINAL_VOLUME_MOUNT_POINT" \
    --mount source="$NEW_BACKUP_VOLUME_NAME",target=/backup \
    --name "$TEMPORARY_CONTAINER_NAME" \
    ubuntu \
    tar -czvf /backup/backup.tar.gz  -C "$ORIGINAL_VOLUME_MOUNT_POINT" .

docker container rm "$TEMPORARY_CONTAINER_NAME"

# docker system df -v
# docker volume inspect "$NEW_BACKUP_VOLUME_NAME"

du -sh $(docker volume inspect --format '{{ .Mountpoint }}' "$NEW_BACKUP_VOLUME_NAME")

docker volume inspect "$NEW_BACKUP_VOLUME_NAME"