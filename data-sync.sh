#!/bin/bash
sorted_files_path=./data/sorted
unsorted_files_path=./data/unsorted
echo -e "\033[33mstep 1: \033[32msyncing followers...\033[0m"
gh api -H "Accept: application/vnd.github+json" /user/followers --jq '.[].login' --paginate > $unsorted_files_path/all-followers
echo -e "\033[33mstep 2: \033[32msyncing following...\033[0m"
gh api -H "Accept: application/vnd.github+json" /user/following --jq '.[].login' --paginate > $unsorted_files_path/all-following
echo -e "\033[33mstep 3: \033[32msorting retrieved files...\033[0m"
sort $unsorted_files_path/all-followers > $sorted_files_path/all-followers
sort $unsorted_files_path/all-following > $sorted_files_path/all-following
echo -e "\033[33mstep 4: \033[32mcomparing sorted files...\033[0m"
comm -12 $sorted_files_path/all-followers $sorted_files_path/all-following > $sorted_files_path/we-follow-eachother
comm -13 $sorted_files_path/all-followers $sorted_files_path/all-following > $sorted_files_path/they-did-not-follow
comm -23 $sorted_files_path/all-followers $sorted_files_path/all-following > $sorted_files_path/i-did-not-follow
echo -e "\033[31mfollowers: \033[32m$(cat $sorted_files_path/all-followers | wc -l)\033[0m"
echo -e "\033[31mfollowing: \033[32m$(cat $sorted_files_path/all-following | wc -l)\033[0m"
echo -e "\033[31mall done.\033[0m"
