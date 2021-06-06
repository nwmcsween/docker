#!/bin/sh
set -e

needed_set "USER_ID" "GROUP_ID" "CHOWN_DIRS" || pexit0 "Required variables unset... not running"
needed_cmd "chown" || pexit1 "Command not found!"

for dir in $CHOWN_DIRS; do
    [ ! -d "$dir" ] && continue
    printf "Chowning %s:%s %s... " "$USER_ID" "$GROUP_ID" "$dir"
    if chown -R "$USER_ID:$GROUP_ID" "$dir" 2> /dev/null; then
        echo "done"
    else
        pexit1 "chown failed!"
    fi
done
