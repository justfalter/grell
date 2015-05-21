FROM justfalter/grell-base:latest

RUN export DEBIAN_FRONTEND=noninteractive && \
    eatmydata apt-get update && \
    eatmydata apt-get install -y gcc g++ make libc6-dev ruby2.2-dev zlib1g-dev libssl-dev patch libxml2-dev libxslt1-dev && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/*

ENV BUILDROOT /build

CMD "${BUILDROOT}/grell/builder/build.sh"

