FROM alpine:3.19

ARG VERSION
ENV WORKDIR=/var/mail
ENV PCHOWN="/var/mail"
ENV PUID=2525
ENV PGID=2525

LABEL org.opencontainers.image.created=${date}\
    org.opencontainers.image.revision=${rev}\
    org.opencontainers.image.title=${title}

WORKDIR ${WORKDIR}
RUN set -eu; apk --no-cache --purge add opensmtpd=${VERSION} && rm -rf /etc/init.d/* /etc/conf.d/*
CMD ["smtpd"]

HEALTHCHECK --interval=10s --timeout=5s\
    CMD printf "EHLO hostname\r\nQUIT\r\n" | nc $(hostname) 25 | grep -q Hello

EXPOSE 25
EXPOSE 456
EXPOSE 587

COPY root /
