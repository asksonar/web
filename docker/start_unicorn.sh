#!/bin/sh
cd /var/src
bundle install --path vendor/bundle

echo 'rsync -a --stats --delete --exclude=.git --exclude=tmp --exclude=log /var/src/ /home/app/webapp/'
rsync -a --stats --delete --exclude=.git --exclude=tmp --exclude=log /var/src/ /home/app/webapp/

cd /home/app/webapp
echo 'bundle exec unicorn -c config/unicorn.rb -D'
bundle exec unicorn -c config/unicorn.rb -D
#bundle exec thin -S /tmp/thin.web.0.sock -D start
