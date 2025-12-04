#!/bin/bash
# 목표: ELECTION.txt 기반 Exit Poll (등간격 샘플 추출)

# 원본 데이터 확인
if [ ! -f ELECTION.txt ]; then
    echo "ELECTION.txt 파일이 없습니다."
    exit 1
fi

# 후보 이름
candidates=("num_1" "num_2" "num_3" "num_4" "num_5" "num_6" "num_7" "num_8")

# 샘플 크기
sample_size=100

# 득표수 맵
declare -A votes
for c in "${candidates[@]}"; do votes[$c]=0; done
invalid_votes=0

# 전체 데이터 로드
mapfile -t all_votes < ELECTION.txt
total_votes=${#all_votes[@]}
step=$(( total_votes / sample_size ))

# 샘플링
for ((i=0; i<sample_size; i++)); do
    index=$(( i * step ))
    (( index >= total_votes )) && index=$(( total_votes - 1 ))
    candidate="${all_votes[index]}"
    if [[ " ${candidates[@]} " =~ " ${candidate} " ]]; then
        ((votes[$candidate]++))
    else
        ((invalid_votes++))
    fi
done

# 결과 출력
echo "== Exit Poll Sample (100표) =="
echo "후보 | 득표 | 퍼센트"
for c in "${candidates[@]}"; do
    percent=$(echo "scale=2; ${votes[$c]}*100/$sample_size" | bc)
    echo "$c | ${votes[$c]} | ${percent}%"
done

invalid_percent=$(echo "scale=2; $invalid_votes*100/$sample_size" | bc)
echo "무효표 | $invalid_votes | ${invalid_percent}%"