FROM node:22-bookworm
ARG workdir
WORKDIR ${workdir}

RUN apt-get update && apt-get install -y chromium && rm -rf /var/lib/apt/lists/*
RUN npm install -g @angular/cli
