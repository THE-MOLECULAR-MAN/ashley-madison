#!/bin/bash
# Tim H 2023
#
# This script will create a docker container and restore backups
# of the Ashley Madison breach into a MySQL v5 database for queries.
#
# This script is intended to be copy and pasted in blocks, not to be directly
# run. 
#
# free space requirements:
#
# Pre-reqs:
#   1) You've downloaded the Ashley Madison breach from BitTorrent. It has
#       compressed .gz files
#   2) You've moved those .gz files into a directory named "ashley_dumps_local"
#       in the home directory of the current user. For example:
#       on Mac:   /Users/tim/ashley_dumps_local/
#       on Linux: /home/tim/ashley_dumps_local/
#   3) You've run the setup-host.sh script in this repo to prepare the host.
#       That script will install docker and decompress the .GZ files.
#
#   After running this script you can run some of the other .sh or .sql files
#   to generate CSV files of interesting information.
#
# References:
# https://blog.devart.com/how-to-restore-mysql-database-from-backup.html
# https://dev.mysql.com/doc/refman/8.0/en/creating-database.html
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/MySQL.Procedural.Importing.NonRDSRepl.html
# https://www.mysqltutorial.org/mysql-export-table-to-csv/

CONTAINER_RUNTIME_NAME="ashley-madison"
VOLUME_NAME="ashley-madison-db-volume"
BASE_IMAGE_AND_TAG="mysql:5.5.40"
# HOST_IP="127.0.0.1"
HOST_IP="10.0.1.49"
MYSQL_PORT="3306"
DEFAULT_MYSQL_PASSWORD='password' # cannot be blank

# create container and run it:
docker run --name "$CONTAINER_RUNTIME_NAME" \
    -e MYSQL_ROOT_PASSWORD="$DEFAULT_MYSQL_PASSWORD" \
    --mount type=bind,source="$HOME",target=/mnt \
    --mount type=bind,source="$HOME/ashley-madison/binds/mysql.conf",target=/etc/my.cnf \
    --mount type=bind,source="$HOME/ashley-madison/binds/sql-queries",target=/root/sql-queries \
    --mount type=bind,source="$HOME/ashley-madison/binds/restore-backups.sh",target=/root/restore-backups.sh \
    --mount source="$VOLUME_NAME",target=/var/lib/mysql \
    -p "$HOST_IP":$MYSQL_PORT:$MYSQL_PORT/tcp \
    -d "$BASE_IMAGE_AND_TAG"

# screen loses track of all environment variables, have to reload them
screen -R -S mysql-restore
CONTAINER_RUNTIME_NAME="ashley-madison5"

# attach to running container
docker exec -it "$CONTAINER_RUNTIME_NAME" bash

# inside the container, verify the bind mount
ls -lah /mnt

# verify the db mount volume
mount | grep /var/lib/mysql

# run the mysql-diable-password.sql
# INTERACTIVE - you'll need to enter the password from above
mysql -p < "/root/sql-queries/mysql-disable-password.sql"

# it should show thread_concurrency = 10 if you loaded my config file
# don't use the -p flag anymore with mysql, don't need password
mysql --execute="SHOW VARIABLES LIKE 'thread_concurrency';"

# launch MySQL without specifying a database
# create the empty database - must be named aminno
mysql --execute="create database aminno;"

# verify access to the dump files inside the container:
ls -lah /mnt/ashley_dumps_local/*.dump

# mark the restore script as executable
chmod u+x "/root/restore-backups.sh"
 
# start the restore, then exit the screen session with Ctrl+D
/bin/bash /root/restore-backups.sh

# wait for 7-10 hours...

# create a snapshot of the live container
docker export --output "$HOME/container-backup1.tar" "$CONTAINER_RUNTIME_NAME" 

# check disk space utilization of volumes, images, containers
docker system df -v

# watch CPU/IO/RAM utilization, ctrl+C to quit it, on the host, outside
# the container:
docker stats
