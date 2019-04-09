FROM alpine
LABEL maintainer "Álvaro Brey <alvaro.brey@imagames.com>"

RUN apk add --no-cache mongodb bash

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
