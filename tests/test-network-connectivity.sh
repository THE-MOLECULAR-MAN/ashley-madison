#!/bin/bash
# Tim H 2023

###############################################################################
# Test network connectivity to MySQL database
###############################################################################

# try to connect from Host, this should work
nmap -Pn -p${MYSQL_PORT} "$HOST_IP"
sudo apt install mysql-client-core-8.0
mysql -h "$HOST_IP" -P "$MYSQL_PORT" --protocol=tcp -u root
