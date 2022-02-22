FROM ubuntu:20.04
MAINTAINER Joe Larson <jpl@showpage.org>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends dpkg-dev nginx inotify-tools supervisor python3-gevent \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

ADD supervisord.conf /etc/supervisor/
ADD nginx.conf /etc/nginx/sites-enabled/default
ADD startup.sh /
ADD scan.py /

ENV DISTS trusty
ENV ARCHS amd64,i386
EXPOSE 80
VOLUME /data
ENTRYPOINT ["/startup.sh"]
