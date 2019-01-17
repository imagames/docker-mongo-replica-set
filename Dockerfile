FROM alpine
MAINTAINER alvaro.brv@gmail.com

RUN apk add --no-cache mongodb bash

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
