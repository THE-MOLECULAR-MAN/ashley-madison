#!/bin/bash
# Tim H 2023

###############################################################################
# after the restores are done - extract useful data to CSV
###############################################################################

# sql won't overwrite an existing CSV file, need to delete it first
rm /tmp/ashley-madison-email-list.csv

# start mysql session to extract email addresses
mysql aminno < binds/sql-queries/mysql-export-emails-to-csv.sql

ls -lah /mnt/*.csv

###############################################################################
# copy it back to laptop
# scp jupyter.int.butters.me:~/ashley-madison-email-list.csv /Users/tim/ashley-madison/
