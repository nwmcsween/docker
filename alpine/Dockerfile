ARG VERSION
FROM alpine:${VERSION} as alpine

RUN set -eu; apk --no-cache --purge upgrade && rm -rf /etc/init.d

FROM scratch

LABEL org.opencontainers.image.title="alpine: small, simple and lean w/ optimized defaults and a simple init"

# Bypass dive-ci
COPY --from=alpine / /

ENTRYPOINT ["/bin/init"]

COPY root /
