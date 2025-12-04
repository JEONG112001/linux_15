#!/bin/bash

if [ ! -f ELECTION.txt ]; then
    echo "ELECTION.txt 파일이 없습니다."
    exit 1
fi

candidates=("num_1" "num_2" "num_3" "num_4" "num_5" "num_6" "num_7" "num_8")
sample_size=100

declare -A votes
for c in "${candidates[@]}"; do
    votes[$c]=0
done
invalid_votes=0

mapfile -t all_votes < ELECTION.txt
total_votes=${#all_votes[@]}
step=$(( total_votes / sample_size ))

for ((i=0; i<sample_size; i++)); do
    index=$(( i * step ))
    if (( index >= total_votes )); then
        index=$(( total_votes - 1 ))
    fi
    candidate="${all_votes[index]}"
    if [[ " ${candidates[@]} " =~ " ${candidate} " ]]; then
        votes[$candidate]=$((votes[$candidate] + 1))
    else
        invalid_votes=$((invalid_votes + 1))
    fi
done

echo "== Exit Poll Sample =="
for c in "${candidates[@]}"; do
    echo "$c | ${votes[$c]}"
done
echo "무효표 | $invalid_votes"