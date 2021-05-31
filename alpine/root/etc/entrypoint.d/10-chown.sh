#!/bin/sh
set -e

needed_set "$PUID" "$PGID" "$PCHOWN" || pexit0 "Required variables unset... not running"
needed_cmd "chown" || pexit1 "Command not found!"

printf "Chowning %s:%s %s... " "$PUID" "$PGID" "$PCHOWN" && chown -R "$PUID:$PGID" "$PCHOWN" 2> /dev/null && echo "done" || pexit1 "chown failed!"
