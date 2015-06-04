# Use phusion/passenger-full as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/passenger-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/passenger-ruby22:0.9.15

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# this should also be set via -v /local/path/to/src:/home/app/webapp
#RUN mkdir /home/app/webapp

# install inotify and rsync so we can automatically copy our src folder
RUN apt-get update
RUN apt-get -y install inotify-tools
RUN apt-get -y install rsync

# write our own nginx.conf
ADD nginx.conf /etc/nginx/nginx.conf
# add environment variables to nginx
ADD env.conf /etc/nginx/main.d/env.conf
# remove the default site
RUN rm /etc/nginx/sites-enabled/default
# set my default site
ADD server.conf /etc/nginx/sites-enabled/server.conf

# add our unicorn log files if they don't exist
RUN mkdir -p /var/log/unicorn
RUN touch /var/log/unicorn/stdout.log
RUN touch /var/log/unicorn/stderr.log

# forward the unicorn logs to docker logs
#RUN mkdir -p /etc/service/unicorn-log-forwarder
#ADD runit/unicorn-log-forwarder /etc/service/unicorn-log-forwarder/run

# run bundle and unicorn upon startup
RUN mkdir -p /etc/my_init.d
#ADD bundle_install.sh /etc/my_init.d/bundle_install.sh
ADD start_unicorn.sh /etc/my_init.d/start_unicorn.sh

# enable nginx
RUN rm -f /etc/service/nginx/down

WORKDIR /home/app/webapp

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*