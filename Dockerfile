#ARG ARCH=

FROM whyour/qinglong:latest

MAINTAINER alex.yao "crazyrico@qq.com"

ENV LANG C.UTF-8
WORKDIR /ql

ADD ./jdc_new.tar.gz .
COPY ./docker-entrypoint.sh ./docker/

EXPOSE 5700
EXPOSE 5701

ENTRYPOINT ["./docker/docker-entrypoint.sh"]
