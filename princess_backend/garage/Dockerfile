FROM dxflrs/garage:v1.3.1 AS garage-bin

FROM alpine:3.21
RUN apk add --no-cache gettext
COPY --from=garage-bin /garage /garage
