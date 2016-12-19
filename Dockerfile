# vim:set ft=dockerfile:
FROM debian:testing-slim

MAINTAINER Andrius Kairiukstis <andrius@kairiukstis.com>

RUN apt-get -yqq update \
&&  apt-get -yqq --no-install-recommends --no-install-suggests install \
      asterisk asterisk-config asterisk-core-sounds-en asterisk-core-sounds-en-gsm asterisk-moh-opsound-gsm \
&&  apt-get clean all \
&&  rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man* /tmp/* /var/tmp/*

RUN ln -s /usr/share/asterisk/sounds/en /var/lib/asterisk/sounds/en

# start asterisk so it creates missing folders and initializes astdb
RUN asterisk && sleep 5

ADD docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/asterisk", "-vvvdddf", "-T", "-W", "-U", "root", "-p"]

