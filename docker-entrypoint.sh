#!/bin/sh

# ElasticSearch Docker Entrypoint as per:
# https://github.com/docker-library/elasticsearch
# Apache Licensed: https://github.com/docker-library/elasticsearch/blob/dce83166a2636abfac110a4555cdf17fd554ae91/LICENSE

set -e

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
  set -- elasticsearch "$@"
fi

# Drop root privileges if we are running elasticsearch
# allow the container to be started with `--user`
if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
  # Change the ownership of /usr/share/elasticsearch/data to elasticsearch
  chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data
  chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/logs 

  set -- gosu elasticsearch "$@"
fi

# As argument is not related to elasticsearch,
# then assume that user wants to run his own process,
# for example a `bash` shell to explore this image
exec "$@"