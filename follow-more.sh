#!/bin/bash
max_requests=242
who_to_follow=./data/sorted/follow-next # follow-next || i-did-not-follow
how_many_lines=$(cat $who_to_follow | wc -l)
for (( t=0 ; t<=$how_many_lines/$max_requests ; t++ )) ; do
	start_time=$(date +%s)
	for (( i=1 ; i<=$max_requests ; i++ )) ; do
		github_account=$(head -n 1 $who_to_follow)
		echo -e "${i} \033[33mfollowing: \033[32m${github_account}\033[0m"
		gh api --method PUT -H "Accept: application/vnd.github+json" /user/following/$github_account && sed -i /$github_account/d $who_to_follow && sleep 3s || break
	done
	seconds_to_sleep=$(($start_time+3600-$(date +%s)))
	echo -e "\033[31msleeping for \033[33m${seconds_to_sleep}s\033[0m" && sleep $seconds_to_sleep;
done
