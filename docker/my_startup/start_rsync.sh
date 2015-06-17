#!/bin/sh
echo 'rsync -a --stats --delete --exclude=.git --exclude=tmp --exclude=log /var/src/ /home/app/webapp/'
rsync -a --stats --delete --exclude=.git --exclude=tmp --exclude=log /var/src/ /home/app/webapp/
