#!/bin/bash

# Remove default stuff
rm /etc/nginx/sites-available/*
rm /etc/nginx/sites-enabled/*

# Make sure all available sites are enabled
while IFS= read -r -u3 -d $'\0' file; do
    fullpath=`readlink -f ${file}`;
    ln -sf $fullpath /etc/nginx/sites-enabled/
done 3< <(find . -maxdepth 4 -type f -iwholename './sites/*/conf/*.nginx' -print0)

# Add docker host ip to hosts file
# https://github.com/docker/docker/issues/1143
echo $(ip route ls | grep ^default | awk '{print $3}') dockerhost >> /etc/hosts

service php5-fpm start && nginx