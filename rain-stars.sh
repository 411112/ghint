#!/bin/bash
who_to_star_file=./data/unsorted/all-followers
unsorted_stared_repos_file=./data/unsorted/stared-repos
sorted_stared_repos_file=./data/sorted/started-repos
unsorted_repos_to_star_file=./data/unsorted/followers-repos
sorted_repos_to_star_file=./data/sorted/followers-repos
total_accounts=$(cat $who_to_star_file | wc -l)
gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /user/starred --paginate -q .[].full_name > $unsorted_stared_repos_file
sort $unsorted_stared_repos_file > $sorted_stared_repos_file
for (( i=0 ; i<$total_accounts ; i++ )) ; do
	who_to_star=$(head -n 1 $who_to_star_file)
	gh api /users/$who_to_star/repos -q .[].full_name >> $unsorted_repos_to_star_file
	sed -i /$who_to_star/d $who_to_star_file
done
sort $unsorted_repos_to_star_file > $sorted_repos_to_star_file
comm -23 $sorted_repos_to_star_file $sorted_stared_repos_file | xargs -I % bash -c 'echo -e "\033[33mstarring \033[32m%\033[0m" && gh api --method PUT -H "Accept: application/vnd.github+json" /user/starred/% ';
