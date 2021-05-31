#!/bin/sh
set -e

needed_set "$PGROUP" "$PUSER" "$PUID" "$PGID" || pexit0 "Required variables unset... not running"
needed_cmd "getent" "delgroup" "deluser" "addgroup" "adduser" "chown" || pexit1 "Command not found!"

idgid="$(getent group "$PGROUP" | cut -d: -f3 > /dev/null 2>&1)"
iduid="$(getent passwd "$PUSER" | cut -d: -f3 > /dev/null 2>&1)"
agroup=

[ -n "$WORKDIR" ] && home="-h $WORKDIR"

# if the gid and idgid differ delete the group
# if the uid and iduid differ delete the user
# if the gid doesnt exist create the user
# if the uid doesn't exist create the group

if [ -n "$idgid" ] && [ "$idgid" -ne "$PGID" ]; then
    printf "Deleting group %s due to gid mismatch in /etc/passwd and \$PGID: %s.. " "$PGROUP" "$PGID" && delgroup "$PGROUP" > /dev/null 2>&1 && echo "done" || pexit1 "delgroup failed!"
fi

if [ -n "$iduid" ] && [ "$iduid" -ne "$PUID" ]; then
    printf "Deleting user %s due to uid mismatch in /etc/passwd and \$PUID: %s.. " "$PUSER" "$PUID" && deluser "$PUSER" > /dev/null 2>&1 && echo "done" || pexit1 "deluser failed!"
fi

if ! getent group "$PGROUP" > /dev/null 2>&1; then
    printf "Creating group: \$PGROUP: %s with \$PGID: %s... " "$PGROUP" "$PGID" && addgroup -g "$PGID" "$PGROUP" > /dev/null 2>&1 && echo "done" || pexit1 "addgroup failed!"
    agroup="-G $PGROUP"
fi

if ! getent passwd "$PUSER" > /dev/null 2>&1; then
    printf "Creating user: \$PUSER: %s with \$PUID: %s... " "$PUSER" "$PUID" && adduser $home -s /bin/sh -D -H -u "$PUID" $agroup "$PUSER" && echo "done" || pexit1 "adduser failed!"
fi

# Allow user logging
printf "Chowning /dev/stderr /dev/stdout to %s:%s... " "$PUSER" "$PGROUP" && chown "$PUSER:$PGROUP" /dev/stderr /dev/stdout && echo "done" || pexit1 "chown failed!"
