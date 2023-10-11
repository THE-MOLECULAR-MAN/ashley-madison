#!/bin/bash
# Tim H 2023

# took ? minutes, 1.7 GB
time mysql aminno < /mnt/ashley_dumps_local/aminno_member_email.dump

# took 60 minutes, 2.3 GB
time mysql aminno < /mnt/ashley_dumps_local/member_details.dump

# took 304 minutes, 13 GB .dump file
time mysql aminno < /mnt/ashley_dumps_local/aminno_member.dump

# took 37 minutes, 9.5 GB .dump file
time mysql aminno < /mnt/ashley_dumps_local/am_am.dump

# took ? minutes, 4.2 GB .dump file
time mysql aminno < /mnt/ashley_dumps_local/member_login.dump
