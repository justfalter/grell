#!/bin/bash
set -e
VENDORDIR=${BUILDROOT}/vendor
SRCDIR=${BUILDROOT}/grell/src
gembuilddir=$(mktemp -d)


cp -v ${SRCDIR}/Gemfile ${gembuilddir}/Gemfile
ln -sf ${SRCDIR}/Gemfile.lock ${gembuilddir}/Gemfile.lock 
cd ${gembuilddir}
bundle config --global path /build/vendor
bundle config --global build.nokogiri --use-system-libraries --with-xml2-include=/usr/include/libxml2
bundle config --global without "development:test"

bundler install --clean

cd ${BUILDROOT}
docker build -f grell/Dockerfile.app -t justfalter/grell:latest .
