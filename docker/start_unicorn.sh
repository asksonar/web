#!/bin/sh
cd /var/src
bundle install --path vendor/bundle

rsync -av --delete --exclude=.git /var/src/ /home/app/webapp/

cd /home/app/webapp
echo 'bundle exec unicorn -c config/unicorn.rb -D'
bundle exec unicorn -c config/unicorn.rb -D
