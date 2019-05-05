FROM alpine:latest

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
  && apk update \
  && apk add --no-cache nodejs npm  bash python-dev make \
  && rm -rf /var/cache/apk/* \
  && mkdir -p /yapi

COPY entrypoint.sh /usr/local/bin/
COPY code/ /yapi/vendors

WORKDIR /yapi/vendors

RUN npm i -g node-gyp yapi-cli npm@latest --registry=https://registry.npm.taobao.org/ \
    && npm i --production --registry=https://registry.npm.taobao.org/

EXPOSE 3000

ENTRYPOINT ["entrypoint.sh"]
