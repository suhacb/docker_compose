FROM node:24-alpine3.21
ARG workdir
ARG PUID=1000
ARG PGID=1000

# If you are running Linux, uncomment the next line.
# RUN addgroup -g ${PGID} appgroup \
# && adduser  -D -G appgroup -u ${PUID} appuser
# RUN chown -R appuser:appgroup "${workdir}"

WORKDIR ${workdir}

ENV NPM_CONFIG_CACHE=/tmp/.npm
USER node

