#!/bin/sh
cd /var/src
bundle install --path vendor/bundle
#bundle install --path /var/vendor/bundle
#bundle exec thin -p 3000 -P /run/thin.pid -l /var/log/thin/out.log -d start
rsync -av --delete --exclude=.git /var/src/ /home/app/webapp/
cd /home/app/webapp
echo 'bundle exec unicorn -c config/unicorn.rb -D'
bundle exec unicorn -c config/unicorn.rb -D
