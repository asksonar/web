#!/bin/sh
echo 'bundle exec thin start -S /tmp/sockets/thin.sock'
bundle exec thin start -S /tmp/sockets/thin.sock
