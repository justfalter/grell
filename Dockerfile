FROM ubuntu:14.04

ADD docker/etc/apt/sources.list.d/brightbox-ruby-ng.list /etc/apt/sources.list.d/brightbox-ruby-ng.list

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C3173AA6 && \
    apt-get update && \
    apt-get install -y eatmydata && \
    eatmydata apt-get upgrade -y && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/*

RUN export DEBIAN_FRONTEND=noninteractive && \
    eatmydata apt-get update && \
    eatmydata apt-get install -y ca-certificates ruby2.2 supervisor memcached libxml2 && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/*

RUN useradd -m grell

RUN export DEBIAN_FRONTEND=noninteractive && \
    eatmydata apt-get update && \
    eatmydata apt-get install -y gcc g++ make libc6-dev ruby2.2-dev zlib1g-dev libssl-dev patch libxml2-dev libxslt1-dev && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/*

RUN export DEBIAN_FRONTEND=noninteractive && \
    eatmydata apt-get update && \
    eatmydata apt-get install -y python-pip && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/*

RUN pip install supervisor-stdout==0.1.1

RUN echo "gem: --no-document" >> /etc/gemrc

RUN gem install bundler


ADD ./src/Gemfile /tmp/app/Gemfile
ADD ./src/Gemfile.lock /tmp/app/Gemfile.lock
WORKDIR /tmp/app
RUN bundle config build.nokogiri --use-system-libraries --with-xml2-include=/usr/include/libxml2/ && \
    eatmydata bundle install --jobs=7

ADD src/ /app
WORKDIR /app

ADD ./docker/ /docker

ENV MEMCACHE_SERVERS 127.0.0.1
ENV GRELL_CONFIG /config/grell.yml

ENTRYPOINT [ "/bin/bash", "/docker/startup.sh" ]

#CMD [ "bundle", "exec", "rackup", "-o", "0.0.0.0" ]
CMD [ "start-dev" ]
