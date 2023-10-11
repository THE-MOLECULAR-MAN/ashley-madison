#!/bin/bash
# Tim H 2023
# https://blog.devart.com/how-to-restore-mysql-database-from-backup.html
# https://dev.mysql.com/doc/refman/8.0/en/creating-database.html
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/MySQL.Procedural.Importing.NonRDSRepl.html
# https://www.mysqltutorial.org/mysql-export-table-to-csv/

# free space requirements:
# the member_details table occupies about 33 GB of file system disk space 
# after being restored

# get onto remote host
ssh jupyter.int.butters.me

CONTAINER_RUNTIME_NAME="ashley-madison5"
VOLUME_NAME="ashley-madison-db-volume"
BASE_IMAGE_AND_TAG="mysql:5.5.40"
# HOST_IP="127.0.0.1"
HOST_IP="10.0.1.49"
MYSQL_PORT="3306"
DEFAULT_MYSQL_PASSWORD='password'

# expand the root file system partition to use the full virtual disk
# sudo apt -y install cloud-guest-utils
# sudo growpart /dev/sda 2
# sudo resize2fs /dev/sda2

# install docker in Ubuntu:
# ../docker/install-docker-ubuntu-server.sh

# extract the compressed dump files:
# cd /mnt/
# gzip -d *dump.gz

# docker volume create "$VOLUME_NAME"
# docker volume ls

# create container and run it:
# known working:
# docker run --name basictest1 -e MYSQL_ROOT_PASSWORD='my-secret-pw' \
#     --mount type=bind,source=/Users/tim,target=/mnt \
#     -p 127.0.0.1:3306:3306/tcp \
#     -d mysql:5.5.40
# docker exec -it basictest1 bash
# docker container stop basictest1
# docker container rm   basictest1

# reset the test:
docker container stop "$CONTAINER_RUNTIME_NAME"
docker container rm   "$CONTAINER_RUNTIME_NAME"

docker run --name "$CONTAINER_RUNTIME_NAME" \
    -e MYSQL_ROOT_PASSWORD="$DEFAULT_MYSQL_PASSWORD" \
    --mount type=bind,source="$HOME",target=/mnt \
    --mount type=bind,source="./binds/mysql.cnf",target=/etc/my.cnf \
    --mount type=bind,source="./binds/sql-queries",target=/root/sql-queries \
    --mount source="$VOLUME_NAME",target=/var/lib/mysql \
    -p "$HOST_IP":$MYSQL_PORT:$MYSQL_PORT/tcp \
    -d "$BASE_IMAGE_AND_TAG"

# attach to running container
docker exec -it "$CONTAINER_RUNTIME_NAME" bash

# adjust MySQL RAM settings - optimize speed for future queries
# copy the contents of mysql.cnf to /etc/my.cnf inside the container

# inside the container, verify the bind mount
ls -lah /mnt

# verify the db mount volume
mount | grep /var/lib/mysql

# launch MySQL without specifying a database, require password, used above
mysql -p

# show the configuration variables, verify the local config worked:
SHOW VARIABLES LIKE '%_size';

# inside MySQL, create the empty database - must be named aminno
create database aminno;

# run the mysql-diable-password.sql
# run the mysql-test-create-table.sql

# restart the containter and test persistence:
docker container restart "$CONTAINER_RUNTIME_NAME"
docker exec -it "$CONTAINER_RUNTIME_NAME" bash
mysql aminno --execute="SELECT * FROM Customers;"
mysql aminno --execute="SHOW VARIABLES LIKE '%_size';"

# verify access to the dump files inside the container:
docker exec -it "$CONTAINER_RUNTIME_NAME" bash
ls -lah /mnt/ashley_dumps_local/*.dump

# backups seem to take about 30 minutes per gigabyte
# https://stackoverflow.com/questions/1493722/mysql-command-for-showing-current-configuration-variables

# screen loses track of all environment variables, have to reload them
screen

echo "#!/bin/bash
# took ? minutes, 1.7 GB
time mysql -p aminno < /mnt/ashley_dumps_local/aminno_member_email.dump

# took 60 minutes, 2.3 GB
time mysql -p aminno < /mnt/ashley_dumps_local/member_details.dump

# took 304 minutes, 13 GB .dump file
time mysql -p aminno < /mnt/ashley_dumps_local/aminno_member.dump

# took 37 minutes, 9.5 GB .dump file
time mysql -p aminno < /mnt/ashley_dumps_local/am_am.dump

# took ? minutes, 4.2 GB .dump file
time mysql -p aminno < /mnt/ashley_dumps_local/member_login.dump
" > "$HOME/restore_sql.sh"

# check disk space size of MySQL db inside the container:
du -sh /var/lib/mysql

# watch CPU/IO/RAM utilization, ctrl+C to quit it, on the host, outside
# the container:
docker stats

###############################################################################
# after the restores are done - create backups
###############################################################################
# take snapshot of container once the restore is done:
docker stop   "$CONTAINER_RUNTIME_NAME"
docker commit --message 'aminno_member_email and member_details restored' "$CONTAINER_RUNTIME_NAME" ashley_madison:backup1
docker start  "$CONTAINER_RUNTIME_NAME"

# verify the image worked:
docker images

###############################################################################
# after the restores are done - extract useful data to CSV
###############################################################################

# sql won't overwrite an existing CSV file, need to delete it first
rm /tmp/ashley-madison-email-list.csv

# start mysql session to extract email addresses
mysql -p aminno

# query to extract the lower case, whitespace trimmed, unique email addresses
# go run the mysql-export-emails-to-csv.sql file on it

# mv /tmp/ashley-madison-email-list.csv /mnt/

###############################################################################
# copy it back to laptop
scp jupyter.int.butters.me:~/ashley-madison-email-list.csv /Users/tim/ashley-madison/

###############################################################################
# after restarting Jupyter:
screen
docker start "$CONTAINER_RUNTIME_NAME"
docker exec -it "$CONTAINER_RUNTIME_NAME" bash
mysql -p aminno



###############
# port forwarding for external access
###############
# 3306

nmap -Pn -p3306,3000 localhost
# nmap -Pn -p3306,3000 jupyter.int.butters.me
sudo apt install mysql-client-core-8.0

# try to connect from Host, this should work
mysql -h localhost -P 3000 --protocol=tcp -u root -p

# "/Users/tim/Library/Application Support/MySQL/Workbench/snippets"#
# https://dev.mysql.com/downloads/file/?id=520007
