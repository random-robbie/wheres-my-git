#!/bin/bash
#
# Usage: ./where.sh targets.txt
#
# The target list should contain one target per line, beginning with http:// or https://
# It first scrapes the target sites for links to other pages, then checks all of those domains for git config files.

check_target () {
	if $(curl -sk --connect-timeout 10 "$1.git/config" | grep -q "repositoryformatversion"); then
		echo "$1.git/config"
	fi
}
export -f check_target
>/tmp/targets.tmp
# Scrape targets to get more targets
echo "Scraping targets..."
cat $1 | parallel -j 25 --bar curl -skL --connect-timeout 10 | grep -Eo "(http|https)://[\da-z./?A-Z0-9\D=_-]*/" | sort -u >>/tmp/targets.tmp
wait
# Test for .git/config files and output to found.txt
echo "Testing new targets..."
cat /tmp/targets.tmp | parallel -j 25 --bar check_target | tee found-jon.txt
#rm /tmp/targets.tmp
if [[ $(cat found-jon.txt) == "" ]]; then
	echo "No results found."
else
	echo "Done."
fi
