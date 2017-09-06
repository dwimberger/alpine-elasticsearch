FROM openjdk:8u131-jre-alpine
MAINTAINER dieter@wwimpi.net

RUN apk --no-cache add curl && \
  curl -o /usr/local/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64" && \
  chmod +x /usr/local/bin/gosu && \
  curl -o elasticsearch-5.5.2.tar.gz -sSL https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.5.2.tar.gz && \
  tar -xzf elasticsearch-5.5.2.tar.gz && \
  rm elasticsearch-5.5.2.tar.gz && \
  mv elasticsearch-5.5.2 /usr/share/elasticsearch && \
  mkdir -p /usr/share/elasticsearch/data /usr/share/elasticsearch/logs /usr/share/elasticsearch/config/scripts && \
  adduser -DH -s /sbin/nologin elasticsearch && \
  chown -R elasticsearch:elasticsearch /usr/share/elasticsearch && \
  apk del curl && \
  rm -rf /var/cache/apk/*

ENV PATH /usr/share/elasticsearch/bin:$PATH

WORKDIR /usr/share/elasticsearch
VOLUME /usr/share/elasticsearch/data

RUN sed -i "1s/.*/#\!\/bin\/sh/" /usr/share/elasticsearch/bin/elasticsearch

COPY config ./config
COPY docker-entrypoint.sh /

EXPOSE 9200 9300
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["gosu", "elasticsearch", "elasticsearch"]

