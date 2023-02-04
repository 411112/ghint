#!/bin/bash
who_to_star_file=./data/unsorted/all-followers
total_accounts=$(cat $who_to_star_file | wc -l)
for (( i=0 ; i<$total_accounts ; i++ )) ; do
	who_to_star=$(head -n 1 $who_to_star_file)
	gh api /users/$who_to_star/repos -q .[].full_name | xargs -I % bash -c 'echo -e "\033[33mstarring \033[32m%\033[0m" && gh api --method PUT -H "Accept: application/vnd.github+json" /user/starred/% ';
	sed -i /$who_to_star/d $who_to_star_file
done
echo "all done"
# beta version
