## Alpine

### Why

There were no simple alpine containers with initalization that wasn't massively bloated or larger than the container itself.

### How

`/bin/init` or `root/bin/init` within the repo, it simply runs init scripts found in `/etc/entrypoint.d` or `root/etc/entrypoint.d` within the repo.

### What

Environment variable used and possible defaults:

````sh
# PUSER and PGROUP are cosmetic but needed for tools that rely on user/group names
${PUSER:=_user} # used for user creation on init
${GROUP:=_user} # used for user creation on init
${PUID:=1000} # used for user creation on init
${PGID:=1000} # used for user creation on init
$WORKDIR # used for chowning based on user created
$PCHOWN # supplementary chowned files/dirs
````

Environment variables provided:

````sh
$PROUTE # default network route ip
````

## FAQ

* Why can't this be an init container, etc?
    * We would need a hook before ENTRYPOINT is exec'ed, the alpine images do not provide this (see https://github.com/alpinelinux/docker-alpine/issues/172).
* Why not s6, runit, etc?
    * Not needed if the container runs a single binary/service, if it runs more consider docker-compose or kubernetes pods.
