#!/bin/sh
rsync -a -i --delete --exclude=.git --exclude=tmp --exclude=log /var/src/ /home/app/webapp/
