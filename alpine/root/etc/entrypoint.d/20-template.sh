#!/bin/sh

stch() {
# -e add escapes to $ and `, -e replace env vars in {{}}, -e replace {{!}} commands
val=$(eval "cat << EOF_\$PPID
$(set -e; sed -e 's:[\$`]:\\&:g' -e 's/{{\s*\([[:alnum:]\/_:-]*\)\s*}}/${\1}/g' -e 's:{{\!\s*\(.*\)\s*}}:$(\1):g')
EOF_\$PPID")
[ "$val" ] && printf "%s\n" "$val"
}

find /etc -type f -name "*.stch" | while read -r tpl; do
     stch < "$tpl" > "${tpl%.stch}"
done
