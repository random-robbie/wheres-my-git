#!/bin/bash
rm /tmp/new.tmp
curl -sk $1 | grep -Eo "(http|https)://[\da-z./?A-Z0-9\D=_-]*/" | sort -u >> /tmp/new.tmp
for ip in `cat /tmp/new.tmp`; do
	if timeout 10s curl -sk $ip.git/config | grep -q "repositoryformatversion"; then
    	printf "$ip.git/config\n"
	echo $ip.git/config\n >> found.txt
	else
    	printf "Not Found\n"
fi
done
