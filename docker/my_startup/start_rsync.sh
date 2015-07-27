#!/bin/sh
#echo 'rsync -a -i --delete --exclude=.git --exclude=tmp --exclude=log /var/src/ /home/app/webapp/'
rsync -a -i --delete --exclude=.git --exclude=tmp --exclude=log /var/src/ /home/app/webapp/
