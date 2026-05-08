FROM node:24-alpine3.21
ARG workdir
WORKDIR ${workdir}

RUN apk add --no-cache chromium && corepack enable

ENV CHROME_BIN=/usr/bin/chromium-browser