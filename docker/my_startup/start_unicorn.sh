#!/bin/sh
cd /home/app/webapp
#echo 'bundle exec unicorn -c config/unicorn.rb -D'
#bundle exec unicorn -c config/unicorn.rb -D
bundle exec unicorn -c config/unicorn.rb
#bundle exec thin -S /tmp/thin.web.0.sock -D start
