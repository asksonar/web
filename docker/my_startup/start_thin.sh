#!/bin/sh
cd /home/app/webapp
echo 'bundle exec thin start -S /tmp/sockets/thin.sock'
bundle exec thin start -S /tmp/sockets/thin.sock
