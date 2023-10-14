#!/bin/bash
# Tim H 2023

du -sh /var/lib/mysql

# after loading but before optimization: 117G /var/lib/mysql
time mysqlcheck --optimize --all-databases

# shortly after starting this command, it shrunk to 79 GB

du -sh /var/lib/mysql

# docker system df -v
# docker stats
