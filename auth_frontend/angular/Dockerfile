FROM node:22.19-alpine
ARG workdir
ARG PUID=1000
ARG PGID=1000

# If you are running Linux, uncomment the next line.
# RUN addgroup -g ${PGID} appgroup \
#  && adduser  -D -G appgroup -u ${PUID} appuser

# RUN mkdir -p "${workdir}" && chown -R appuser:appgroup "${workdir}"
WORKDIR ${workdir}
ENV NPM_CONFIG_CACHE=/tmp/.npm

RUN npm install -g @angular/cli


ENV CHOKIDAR_USEPOLLING=true \
    CHOKIDAR_INTERVAL=300
USER node

# CMD ["ng", "serve", "--host", "0.0.0.0", "--disable-host-check"]
EXPOSE 4200
CMD ["ng", "serve", "--host", "0.0.0.0"]