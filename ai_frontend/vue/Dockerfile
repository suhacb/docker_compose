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

ENV CHOKIDAR_USEPOLLING=true \
    CHOKIDAR_INTERVAL=300
USER node

EXPOSE 5173
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]
