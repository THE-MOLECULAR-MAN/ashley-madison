#!/bin/bash
# Tim H 2023

# get onto Docker host or use your localhost
# ssh jupyter.int.butters.me
# pull down this repo:
# cd "$HOME" || exit 1
# git clone https://github.com/THE-MOLECULAR-MAN/ashley-madison.git
# cd ashley-madison || exit 1

# expand the root file system partition to use the full virtual disk
sudo apt -y install cloud-guest-utils
sudo growpart /dev/sda 2
sudo resize2fs /dev/sda2

# install docker in Ubuntu:
# https://github.com/THE-MOLECULAR-MAN/homelab-public/blob/main/linux/install-docker-ubuntu-server.sh

# extract the compressed dump files:
cd /mnt/ashley_dumps_local
gzip -d *dump.gz