#!/usr/bin/env bash

# This script do only handle "ordinary" adult sites.
# For any snuff or mobile domains, please remove manually in respective
# file from the submit_here/ folder
# ---
# RUN THIS SCRIPT FROM THE REPO ROOT FOLDER
# with this command
# bash toolbox/del_hosts.sh
# ---
# This Script is only to DELETE domains

set -e #-x

# Some default functions
git_up () {
    git add -A . && git commit -am "Work in progress"
    git checkout "master"
    git pull --rebase
}

git_branch () {
	git checkout -b "removal/$domain"
}

printf "\n\tThis Script is only to DELETE domains\n\n"

read -rp "Enter domain to handle as 'domain.tld': " domain

read -rp "Enter Clefspeare13 Pornhost Issue ID: " issue

printf "\nDeleting domain(s): %s\n" "$domain"

git_up && git_branch

sed -i "/${domain}\$/d" "submit_here/hosts.txt" "submit_here/mobile.txt" \
	"submit_here/snuff.txt" "submit_here/strict_adult.txt"

printf "\nGit commit %s\nwith Pornhost issue ID: $issue\n" "$domain"

printf "Removal of %s\n\n" "${domain}" >> commit.txt # Use two blank lines to ensure header

printf "Closes https://github.com/Clefspeare13/pornhosts/pull/%s\n" ${issue}  >> commit.txt
printf "\n\nPing: @Clefspeare13 @Spirillen\n" >> commit.txt

whois -H "${domain}" | tee -a commit.txt >/dev/null

git commit -aF commit.txt && rm -f commit.txt

printf "\n\n\nNow please verify your committed domains in

submit_here/hosts.txt

Before you pushes this with

git push -u origin removal/%s

Dont forget to return to master branch when you have pushed

echo -e "You have Committed the following domains to:\n"
echo -e "submit_here/hosts.txt\n"

git log --word-diff=porcelain -1 -p  -- submit_here/hosts.txt | \
  grep -e "^-" | cut -d "-" -f2 | grep -vE "^(#|$)"

git commit 'submit_here/'

printf "\nIf you are happy and the changes looks right. Commit with

'git checkout master removal/%s'\n\n" "$domain"

# Copyright: https://www.mypdns.org/
# Content: https://www.mypdns.org/p/Spirillen/
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
