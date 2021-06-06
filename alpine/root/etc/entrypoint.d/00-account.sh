#!/bin/sh
set -e

needed_set "GROUP_NAME" "USER_NAME" "USER_ID" "GROUP_ID" || pexit0 "Required variables unset... not running"
needed_cmd "getent" "delgroup" "deluser" "addgroup" "adduser" "chown" || pexit1 "Command not found!"

idgid="$(getent group "$GROUP_NAME" | cut -d: -f3 > /dev/null 2>&1)"
iduid="$(getent passwd "$USER_NAME" | cut -d: -f3 > /dev/null 2>&1)"
agroup=

[ -n "$WORKDIR" ] && home="-h $WORKDIR"

# if the gid and idgid differ delete the group
# if the uid and iduid differ delete the user
# if the gid doesnt exist create the user
# if the uid doesn't exist create the group

if [ -n "$idgid" ] && [ "$idgid" -ne "$GROUP_ID" ]; then
    printf "Deleting group %s due to gid mismatch in /etc/passwd and \$GROUP_ID: %s.. " "$GROUP_NAME" "$GROUP_ID"
    if delgroup "$GROUP_NAME" > /dev/null 2>&1; then
        echo "done"
    else
        pexit1 "delgroup failed!"
    fi
fi

if [ -n "$iduid" ] && [ "$iduid" -ne "$USER_ID" ]; then
    printf "Deleting user %s due to uid mismatch in /etc/passwd and \$USER_ID: %s.. " "$USER_NAME" "$USER_ID"
    if deluser "$USER_NAME" > /dev/null 2>&1; then
        echo "done"
    else
        pexit1 "deluser failed!"
    fi
fi

if ! getent group "$GROUP_NAME" > /dev/null 2>&1; then
    printf "Creating group: \$GROUP_NAME: %s with \$GROUP_ID: %s... " "$GROUP_NAME" "$GROUP_ID"
    if addgroup -g "$GROUP_ID" "$GROUP_NAME" > /dev/null 2>&1; then
        echo "done"
    else
        pexit1 "addgroup failed!"
    fi
    agroup="-G $GROUP_NAME"
fi

if ! getent passwd "$USER_NAME" > /dev/null 2>&1; then
    printf "Creating user: \$USER_NAME: %s with \$USER_ID: %s... " "$USER_NAME" "$USER_ID"
    if adduser $home -s /bin/sh -D -H -u "$USER_ID" $agroup "$USER_NAME" 2>&1; then
        echo "done"
    else
        pexit1 "adduser failed!"
    fi
fi

# Allow user logging
printf "Chowning /dev/stderr /dev/stdout to %s:%s... " "$USER_NAME" "$GROUP_NAME"
if chown "$USER_NAME:$GROUP_NAME" /dev/stderr /dev/stdout 2>&1; then
    echo "done"
else
    pexit1 "chown failed!"
fi
