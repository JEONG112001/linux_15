#!/bin/bash

if [ ! -f ELECTION.txt ]; then
    echo "ELECTION.txt 파일이 없습니다."
    exit 1
fi

# 후보 이름 (형식 유지)
candidates=("num_1" "num_2" "num_3" "num_4" "num_5" "num_6" "num_7" "num_8")

# 표본 크기
sample_size=100

# 득표수 초기화
declare -A votes
for c in "${candidates[@]}"; do
    votes[$c]=0
done
invalid_votes=0