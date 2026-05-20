FROM node:24-bookworm
ARG workdir
WORKDIR ${workdir}

RUN npx -y playwright@1.60.0 install --with-deps chromium && corepack enable