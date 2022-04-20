#!/bin/bash

if [ -z $1 ]; then
  echo "You need to pass a step number (1 - 3)"
  exit 1;
fi

if (( $1 < 1 || $1 > 3 )); then
  echo "Only steps 1 through 3 exist!"
  exit 1;
fi

if [ $1 = 1 ]; then
  sudo cp -r step_1/html /usr/share/nginx
  sudo cp -r step_1/images /usr/share/nginx
elif [ $1 = 2 ]; then
  sudo cp -r step_2/html /usr/share/nginx
elif [ $1 = 3 ]; then
  sudo mkdir -p /tmp/nginx/cache
fi

sudo cp -r step_$1/conf.d/* /etc/nginx/conf.d

sudo nginx -t
sudo nginx -s reload
if [ $? = 0 ]; then
  echo "NGINX successfully reloaded"
fi

