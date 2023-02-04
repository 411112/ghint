#!/bin/bash
option=followers # followers || following
cat ./data/sorted/follow-next > ./data/unsorted/follow-next
who_to_check_file=./data/unsorted/all-followers # all-following || all-followers
for (( i=1 ; i<$(cat $who_to_check_file | wc -l) ; i++ )) ; do
	who_to_check=$(head -n 1 $who_to_check_file)
	their_total_followings=$(gh api /users/$who_to_check -q .following)
	if (( 1000<$their_total_followings )) ; then
		echo -e "\033[33mchecking:\033[32m ${who_to_check}\033[0m"
		gh api -H "Accept: application/vnd.github+json" /users/$who_to_check/$option --paginate --jq='.[].login' > ./data/unsorted/possible-followers
		sort ./data/unsorted/possible-followers > ./data/sorted/possible-followers
		comm -23 ./data/sorted/possible-followers ./data/sorted/all-following >> ./data/unsorted/follow-next
	fi
	sed -i /$who_to_check/d $who_to_check_file
done
sort ./data/unsorted/follow-next | uniq > ./data/sorted/follow-next
echo -e "\033[33mtotal: \033[32m$(cat ./data/sorted/follow-next | wc -l)\033[0m"
sed -i /411112/d ./data/sorted/follow-next # exclude my username
