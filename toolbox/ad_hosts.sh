#!/usr/bin/env bash

# This Script is only to commit new domains. Only one ad the time
#
# This script do only handle "ordinary" adult sites.
# For any snuff or mobile domains, please add manually to respective
# file in the submit_here/ folder
#
# RUN THIS SCRIPT FROM THE REPO ROOT FOLDER
# with this command
# bash toolbox/ad_hosts.sh

set -e #-x

cd "$(git rev-parse --show-toplevel)"

# Some default functions
git_up () {
    git add -A . && git commit -am "Work in progress"
    #git pull --rebase
    git checkout "master"
    git pull
}

git_branch () {
	git checkout -b "release/$domain"
	#git branch --set-upstream-to=origin/release/"$domain" release/"$domain"
}

# Collect information

echo -e "\nNew porno domain\n\n"
echo -e "You can exit this script with 'ctrl+c'\n\n"

read -rp "Enter 1 domain to handle as 'domain.tld': " domain

# Request for the needs of www. for primary domain or both
printf "1. Use %s\n" "${domain}"
printf "2. Use wwww.%s\n" "${domain}"
printf "3. Use %s + www.%s\n" "${domain}" "${domain}"

read -erp "Which combination do we need [1/2/3]?: " suffix

# Ask for additional third level domains to be submitted

printf "\nWould you like to add any additional domains?\n\nMax 1 domain per line\n\n"

additional=()
while IFS= read -r -p "(End with an empty new line): " line; do
    [[ $line ]] || break  # break if line is empty
    additional+=("$line")
done

read -rp "Enter Clefspeare13 Pornhost Issue ID: " issue

read -rp "Enter MyDNS.org Issue ID: " tissue

read -rp "Enter spirillen Pornhost Issue ID: " pissue

######################
# Script at work...  #
######################

printf "\nAdding domain: %s\n" "$domain"

git_up && git_branch

echo -e "${domain}\n\n" >> commit.txt
echo "This commit will add the following domains" >> commit.txt

case $suffix in
  1)
	echo "$domain" >> 'submit_here/hosts.txt'
	echo "  - $domain" >> 'commit.txt'
	;;

  2)
	echo "www.$domain" >> "submit_here/hosts.txt"
	echo "  - www.$domain" >> 'commit.txt'
	;;

  3)
	echo -e "$domain\nwww.$domain" "" >> "submit_here/hosts.txt"
	echo -e "  - $domain\n  - www.$domain" >> 'commit.txt'
	;;
  *)
	echo "Invalid input..."
 ;;
esac

# Append hosts file specific requirements
if [ -n "${additional[0]}" ]
then
    printf "Appending additional hosts requirements:"
    printf '%s\n' "${additional[@]}" >> 'submit_here/hosts.txt'
    echo -e "  - ${additional[@]}" >> 'commit.txt'
fi

if [ -n "$issue" ]
then
	echo "Closes https://github.com/Clefspeare13/pornhosts/issues/${issue}" >> 'commit.txt'
fi

if [ -n "$pissue" ]
then
	echo "Source: https://github.com/spirillen/pornhosts/issues/${pissue}" >> 'commit.txt'
fi

if [ -n "$tissue" ]
then
	echo "Source: https://www.mypdns.org/T$tissue" >> 'commit.txt'
fi

echo "Ping: @Clefspeare13 @Spirillen" >> 'commit.txt'

echo "Committing $domain"

git commit -aF 'commit.txt' && rm -f 'commit.txt'

printf "\n\nNow please verify your committed domains in submit_here/hosts.txt

Before for pushes this with

'git push -u origin release/%s'\n\n" "$domain"

echo -e "You have Committed the following domains:\n"

git log --word-diff=porcelain -1 -p  -- submit_here/hosts.txt | \
  grep -e "^+" | cut -d "+" -f2 | grep -vE "^(#|$)"

# Copyright: https://www.mypdns.org/
# Contact: https://www.mypdns.org/p/Spirillen/
# Source: https://github.com/Clefspeare13/pornhosts
# License: https://www.mypdns.org/w/License
# License Comment: GNU AGPLv3, MODIFIED FOR NON COMMERCIAL USE
#
# License in short:
# You are free to copy and distribute this file for non-commercial uses,
# as long the original URL and attribution is included.
#
# Please forward any additions, corrections or comments by logging an
# issue at https://www.mypdns.org/maniphest/
