ARG version=3.13
FROM alpine:${version} as base

RUN apk --no-cache --purge upgrade && \
    apk --no-cache add su-exec && \
    rm -rf /etc/init.d && rm -rf /etc/conf.d

FROM scratch

LABEL org.opencontainers.image.title="Alpine image with an entrypoint (/etc/entrypoint.d/), a simple sh based init and various entrypoint scripts"

# Bypass dive-ci
COPY --from=base / /

ENTRYPOINT ["/bin/init"]
CMD ["/bin/sh"]

COPY root /
