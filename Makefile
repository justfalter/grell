base_dir:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
docker_bin:=$(shell which docker)
VENDOR_CONTAINER=grell-vendor-data
APP_ENV=:"production"

.PHONY: base vendor builder build clean

all: build

base:
	docker build -f Dockerfile.base -t justfalter/grell-base:latest .

vendor:
	docker inspect $(VENDOR_CONTAINER) 2>&1 >/dev/null || \
	  docker run --name $(VENDOR_CONTAINER) -v /build/vendor busybox /bin/true

builder: base
	docker build -f Dockerfile.builder -t justfalter/grell-builder:latest .

build: builder base vendor
	docker run --rm -ti \
	  --volumes-from $(VENDOR_CONTAINER) \
	  -v /var/run/docker.sock:/var/run/docker.sock \
	  -v $(docker_bin):/usr/bin/docker \
	  -v $(base_dir):/build/grell justfalter/grell-builder:latest


clean:
	docker rm -v $(VENDOR_CONTAINER) >/dev/null 2>&1  || /bin/true
