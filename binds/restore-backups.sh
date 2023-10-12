#!/bin/bash
# Tim H 2023

# total time is 677 minutes, or about 11.2 hours

# https://stackoverflow.com/questions/1493722/mysql-command-for-showing-current-configuration-variables

# TODO: switch this to be a for loop on *.dump files
# took 74 minutes, 1.7 GB .dump file
time mysql aminno < /mnt/ashley_dumps_local/aminno_member_email.dump

# took 62 minutes, 2.3 GB .dump file
time mysql aminno < /mnt/ashley_dumps_local/member_details.dump

# took 322 minutes, 13 GB .dump file
time mysql aminno < /mnt/ashley_dumps_local/aminno_member.dump

# took 41 minutes, 9.5 GB .dump file
time mysql aminno < /mnt/ashley_dumps_local/am_am.dump

# took 178 minutes, 4.2 GB .dump file
time mysql aminno < /mnt/ashley_dumps_local/member_login.dump

echo "restore-backups.sh finished successfully."
