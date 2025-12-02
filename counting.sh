#!/bin/bash
# 목표: 후보별 득표 수 계산 및 출력 (총 투표자 1000명 기준)

echo "== 개표 통계 =="

# 후보 8명
candidates=("num_1" "num_2" "num_3" "num_4" "num_5" "num_6" "num_7" "num_8")

# 득표 수 초기화
votes=(0 0 0 0 0 0 0 0)

# 무효표 변수
invalid_votes=0

# 총 투표수 고정
total_votes=1000

# ELECTION.txt 파일 존재 확인
if [ ! -f ELECTION.txt ]; then
    echo "ELECTION.txt 파일이 없습니다."
    exit 1
fi

# ELECTION.txt에서 투표 읽기
while read -r candidate; do
    valid=false
    for i in "${!candidates[@]}"; do
        if [[ "$candidate" == "${candidates[i]}" ]]; then
            votes[i]=$((votes[i]+1))
            valid=true
            break
        fi
    done

    # 후보가 아니면 무효표 증가
    if [ "$valid" = false ]; then
        invalid_votes=$((invalid_votes+1))
    fi
done < ELECTION.txt

echo "후보 | 득표 | 퍼센트"
for i in "${!candidates[@]}"; do
    percent=$(echo "scale=2; ${votes[i]}*100/$total_votes" | bc)
    echo "${candidates[i]} | ${votes[i]} | ${percent}%"
done

# 무효표 출력
invalid_percent=$(echo "scale=2; $invalid_votes*100/$total_votes" | bc)
echo "무효표 | $invalid_votes | ${invalid_percent}%"

{
    echo "== 전체 투표 결과 =="
    echo "후보 | 득표 | 퍼센트"
    for i in "${!candidates[@]}"; do
        percent=$(echo "scale=2; ${votes[i]}*100/$total_votes" | bc)
        echo "${candidates[i]} | ${votes[i]} | ${percent}%"
    done
    echo "무효표 | $invalid_votes | ${invalid_percent}%"
} > election_results.txt

echo "결과가 election_results.txt에 저장되었습니다."