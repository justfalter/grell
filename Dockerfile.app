FROM justfalter/grell-base:latest

RUN export DEBIAN_FRONTEND=noninteractive && \
    eatmydata apt-get update && \
    eatmydata apt-get install -y supervisor memcached python-setuptools && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/*

RUN easy_install supervisor-stdout==0.1.1

ADD vendor/ /vendor
ADD grell/docker/ /docker
ADD grell/src/ /app
WORKDIR /app

RUN bundle config --global path /vendor
RUN su -c "bundle config --global path /vendor" grell

ENV GRELL_CONFIG /config/grell.yml
ENV RAILS_ENV=production

ENTRYPOINT [ "/bin/bash", "/docker/startup.sh" ]

CMD [ "start" ]
