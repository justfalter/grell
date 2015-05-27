FROM justfalter/grell-base:latest

RUN export DEBIAN_FRONTEND=noninteractive && \
    eatmydata apt-get update && \
    eatmydata apt-get install -y supervisor memcached python-setuptools nginx curl && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/*

RUN easy_install supervisor-stdout==0.1.1

RUN mkdir /swagger-ui
RUN mkdir /swagger-ui/swagger-ui
RUN curl https://codeload.github.com/swagger-api/swagger-ui/tar.gz/v2.1.5-M2 | tar xzf - -C /swagger-ui/swagger-ui --strip 2 swagger-ui-2.1.5-M2/dist

RUN chown -R www-data:www-data /swagger-ui

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
