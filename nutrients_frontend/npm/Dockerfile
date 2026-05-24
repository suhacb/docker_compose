FROM node:24-bookworm
ARG workdir
WORKDIR ${workdir}

RUN apt-get update && apt-get install -y chromium && rm -rf /var/lib/apt/lists/*
RUN npx -y playwright@1.60.0 install --with-deps chromium && corepack enable