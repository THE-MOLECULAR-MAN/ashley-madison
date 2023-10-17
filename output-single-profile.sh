#!/bin/bash
# Tim H 2023
#
# designed to be run from Jupyter

PROFILE_NUMBER="$1"
HOST_IP="10.0.1.49"
MYSQL_PORT="3306"
OUTPUT_FILEPATH="/nfs_synology_jupyter/ashley-madison-profile-$PROFILE_NUMBER.txt"

sed "s\\REPLACEME\\${PROFILE_NUMBER}\\g" \
    "$HOME/ashley-madison/binds/sql-queries/single-profile-dump.sql" | \
    mysql -h "$HOST_IP" -P "$MYSQL_PORT" --protocol=tcp -u root aminno > \
    "$OUTPUT_FILEPATH"

cat "$OUTPUT_FILEPATH"
