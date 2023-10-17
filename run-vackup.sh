#!/bin/bash
# Tim H 2023



screen -S vackup

# show current size of the db volume
docker volume ls

docker system df -v
# original size was 90.97 GB, after 1 full maintanence cycle to shrink it
# tarbal using GZIP=-2 and otherwise defaults was: 33 GB, took 195 minutes
# tarbal using GZIP=-9 and otherwise defaults was: 33 GB, took 196 minutes
# time to SHA256 hash the file: 7 minutes

rm  "ashley-db-backup-test1.tar.gz"

# do not put a path on the output file.
date
BACKUP_FILENAME="ashley-db-backup-test2.tar.gz"
time GZIP=-9 vackup export ashley-madison-db-volume "$BACKUP_FILENAME"
time sha256sum "$BACKUP_FILENAME" > "${BACKUP_FILENAME}.sha256"
ls -lah "$BACKUP_FILENAME" "${BACKUP_FILENAME}.sha256"
date
