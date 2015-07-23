#!/bin/sh
cd /home/app/webapp
#echo 'bundle exec unicorn -c config/unicorn.rb -D'
#bundle exec unicorn -c config/unicorn.rb -D
#bundle exec unicorn -c config/unicorn.rb
#echo 'bundle exec thin -S /tmp/thin.web.0.sock start'
#bundle exec thin -S /tmp/thin.web.0.sock start
echo 'bundle exec rails server -p 5000 -b 0.0.0.0'
bundle exec rails server -p 3000 -b 0.0.0.0
