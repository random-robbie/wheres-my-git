#!/bin/bash
rm /tmp/new.tmp
curl -sk $1 | grep -Eo "(http|https)://[\da-z./?A-Z0-9\D=_-]*/" | sort -u >> /tmp/new.tmp
for ip in `cat /tmp/new.tmp`; do
        if curl -sk $ip.git/config | grep -q "repositoryformatversion"; then
        printf "$ip.git/config\n"
        else
        printf "Not Found\n"
fi
done
